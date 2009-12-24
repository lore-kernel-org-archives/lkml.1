Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZLXVzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZLXVzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 16:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbZLXVzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 16:55:12 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53039 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZLXVzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 16:55:11 -0500
To: ebiederm@xmission.com
Cc: michael@laptop.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, andi@firstfloor.org,
       david@lang.hm, socketcan@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       herbert@gondor.apana.org.au, Valdis.Kletnieks@vt.edu, bdonlan@gmail.com,
       zbr@ioremap.net, cscott@cscott.net, jmorris@namei.org,
       bernie@codewiz.org, mrs@mythic-beasts.com, randy.dunlap@oracle.com,
       xiyou.wangcong@gmail.com
Subject: Re: A basic question about the security_* hooks
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091224022902.GA24234@heat>
	<4B32F304.4040609@schaufler-ca.com>
	<m1hbrgildc.fsf@fess.ebiederm.org>
In-Reply-To: <m1hbrgildc.fsf@fess.ebiederm.org>
Message-Id: <200912250655.HEC04690.FFVJQSOLHOtMFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 25 Dec 2009 06:55:08 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> My immediate impression is that the big limitation today is the
> sharing of the void * security data members of strucutres.

I think the time to change "void * security" is approaching.

What about allocating dedicated "void *" for each in-tree security modules and
let proposed security modules use "void * security" so that proposed security
modules can be evaluated without allocating dedicated "void *", something like

  struct foo {
      ...
  #ifdef CONFIG_SECURITY_SELINUX
    	void *selinux;
  #endif
  #ifdef CONFIG_SECURITY_SMACK
  	void *smack;
  #endif
  #ifdef CONFIG_SECURITY_PROPOSED
  	void *security
  #endif
  }
  
  struct bar {
      ...
  #ifdef CONFIG_SECURITY_SELINUX
  	void *selinux;
  #endif
  #ifdef CONFIG_SECURITY_PROPOSED
  	void *security
  #endif
  }

?

Regarding TOMOYO, "void * security" automatically added to many structure is
nothing but waste of memory because TOMOYO don't need "void * security" except
"struct task_struct".
