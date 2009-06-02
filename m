Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbZFBFeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbZFBFeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZFBFea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:34:30 -0400
Received: from mailgw3.cms.com ([202.75.200.223]:2359 "EHLO cms.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753778AbZFBFe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:34:29 -0400
X-Originating-IP: 172.19.23.105
X-Auth-User: vibi_sreenivasan@cms.com
X-Filename: C:\PROGRA~1\MailScan\in\SMT4071622686990.TMP
Subject: Re: [PATCH]:RESEND : Return proper error value on failure of
	dentry_open
From: vibi sreenivasan <vibi_sreenivasan@cms.com>
Reply-To: vibi_sreenivasan@cms.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Mimi Zohar <zohar@us.ibm.com>,
       Kylene Hall <kylene@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Reiner Sailer <sailer@watson.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20090601222105.16e20612.akpm@linux-foundation.org>
References: <1243836708.2163.3.camel@system> <4A238625.8060002@gmail.com>
	 <1243844849.2327.27.camel@system> <4A2393DE.10300@gmail.com>
	 <20090601222105.16e20612.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: CMS
Date: Tue, 02 Jun 2009 11:05:40 +0530
Message-Id: <1243920940.2170.12.camel@system>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8)
Content-Transfer-Encoding: 7bit
X-Trained: 2
X-MS-ContentScanSkipped: Mail Not From Internet
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
	Thanks for spending your time on my patch.
> > What bug did you hit?
i was using linus tree & not linux-next.
in that the code fragment was different
it was

		file = dentry_open(dentry, mnt, O_RDONLY, current->cred);
		rc = get_path_measurement(iint, file, dentry->d_name.name);
	}
out:
	mutex_unlock(&iint->mutex);
	if (file)
		fput(file);
	kref_put(&iint->refcount, iint_free);
	return 0;

So i hit a bug in fput.

My sincere apologies for taking all of yours valuable time.
I will take care that any of my future contributions will be
based on linux-next.

Thanks & Regards
vibi sreenivasan

> 	if (!(iint->flags & IMA_MEASURED)) {
> 		struct dentry *dentry = dget(path->dentry);
> 		struct vfsmount *mnt = mntget(path->mnt);
> 
> 		file = dentry_open(dentry, mnt, O_RDONLY | O_LARGEFILE,
> 				   current_cred());
> 		if (IS_ERR(file)) {
> 			pr_info("%s dentry_open failed\n", dentry->d_name.name);
> 			rc = PTR_ERR(file);
> 			file = NULL;
> 			goto out;
> 		}
> 		rc = get_path_measurement(iint, file, dentry->d_name.name);
> 	}
> out:
> 	mutex_unlock(&iint->mutex);
> 	if (file)
> 		fput(file);
> 	kref_put(&iint->refcount, iint_free);
> 	return 0;
> }
> 
> The handling of `file' looks OK to me.
> 
> otoh the function just drops the error code on the floor.  Shouldn't it
> return `rc'?
> 
> 
> 


