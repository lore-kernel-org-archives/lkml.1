Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZFAINL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZFAINL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZFAIM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:12:57 -0400
Received: from mailgw3.cms.com ([202.75.200.223]:24514 "EHLO cms.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754365AbZFAIM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:12:57 -0400
X-Originating-IP: 172.19.23.105
X-Auth-User: vibi_sreenivasan@cms.com
X-Filename: C:\PROGRA~1\MailScan\in\SMT9698954395626.TMP
Subject: Re: [PATCH]:Return proper error value on failure of dentry_open
From: vibi sreenivasan <vibi_sreenivasan@cms.com>
Reply-To: vibi_sreenivasan@cms.com
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mimi Zohar <zohar@us.ibm.com>, Kylene Hall <kylene@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Reiner Sailer <sailer@watson.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A238625.8060002@gmail.com>
References: <1243836708.2163.3.camel@system>  <4A238625.8060002@gmail.com>
Content-Type: text/plain
Organization: CMS
Date: Mon, 01 Jun 2009 13:40:51 +0530
Message-Id: <1243843851.2327.7.camel@system>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8)
Content-Transfer-Encoding: 7bit
X-Trained: 2
X-MS-ContentScanSkipped: Mail Not From Internet
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,
	thanks for pointing that out.
> >  out:
> >  	mutex_unlock(&iint->mutex);
> > -	if (file)
> > +	if (IS_ERR(file))
> >  		fput(file);
extremely sorry it was 
	if(!IS_ERR(file))
		fput(file);
i will send that patch again

> 
> This makes no sense at all. If it is IS_ERR, i.e. some negative value,
> you don't want to pass it to fput. 'if (file)' was perfectly correct.
	if(file) is true for file != 0 , ie even if file is a -ve error
	value.
	so while fput dereference file ,this can cause a bug to be
	triggered.
	I actually had one.

Thanks & regards
vibi sreenivasan
> 


