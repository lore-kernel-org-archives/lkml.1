Return-Path: <linux-kernel-owner+w=401wt.eu-S933009AbYCFOdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009AbYCFOdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760986AbYCFOc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:32:58 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:60575 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760459AbYCFOc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:32:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fLK0rFwGCcc1oeAc0nEAzmPf2sdawW1Iqs7lV57DBtaOLI8j3K8GRfNtI1ZK22ZDDSfU8ab0GAgn3kD05iD2VD2G84Tw1w6ZHqu5oqkdmWklAlwJjIIGjSvXk4YE8SZcr2SMb9ocE3EYpY2GSX5FBF/q2Lu/Ba+/d02eaR59LFg=
Message-ID: <1865922a0803060632kb63405fj3d255472fb2e555f@mail.gmail.com>
Date: Thu, 6 Mar 2008 16:32:51 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [PATCH -v8 -rc3] Security: Introduce security= boot parameter
Cc: "Chris Wright" <chrisw@sous-sol.org>,
       "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Eric Paris" <eparis@parisplace.org>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Paul Moore" <paul.moore@hp.com>, "Alexey Dobriyan" <adobriyan@sw.ru>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
In-Reply-To: <Xine.LNX.4.64.0803070025440.16767@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306121913.GA8506@ubuntu>
	 <Xine.LNX.4.64.0803070025440.16767@us.intercode.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Thu, Mar 6, 2008, James Morris <jmorris@namei.org> wrote:
> On Thu, 6 Mar 2008, Ahmed S. Darwish wrote:
>
>  >     Handle Andrew's concerns:
>  >     - Use __init and __initdata in appropriate places.
>  >     - Do not rely upon dummy_ops layout, use C99 initializations.
>  >     - Use DEFINE_SPINLOCK instead of dynamic initialization.
>
>  The spinlock is not needed now, if security_module_enable() can only be
>  called during boot via an initcall.
>

Will do.

Would you mind answering my confusions below so I can do the change
with good understanding ?

I see preempt_disable() before calling security and vfs_caches init,
but what will prevent two processors/cores from executing
security_module_enable() concurrently (thus possibly corrupting
chosen_lsm) ?
security_module_enable() is also now used in __init init_smk_fs().

Or the init path got executed serially ?

Thank you,

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
