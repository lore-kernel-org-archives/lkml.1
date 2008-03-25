Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYCYLqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYCYLqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 07:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYCYLp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 07:45:58 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55107 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbYCYLp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 07:45:57 -0400
To: neilb@suse.de, miklos@szeredi.hu
Cc: viro@ZenIV.linux.org.uk, haveblue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org,
       linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: Re: r-o bind in nfsd
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080321155451.GU10722@ZenIV.linux.org.uk>
	<E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu>
	<20080321163520.GV10722@ZenIV.linux.org.uk>
	<E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu>
	<18408.26863.617591.836548@notabene.brown>
In-Reply-To: <18408.26863.617591.836548@notabene.brown>
Message-Id: <200803252045.CGB04105.HLSQFOJMtOFVOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 25 Mar 2008 20:45:53 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> Maybe some enhancement to the 'intent' structure with a similar
> effect could be done instead.
> 
> Then you could, presumably, put a security hook somewhere in
> link_path_walk for those modules (like AppArmor) which want to do
> checks based on the namespace.

I think link_path_walk() is not a good place to insert new LSM hooks
for pathname based access control (AppArmor and TOMOYO) purpose because

  (1) The kernel don't know what operation (open/create/truncate etc.) will be
      done at the moment of link_path_walk().

  (2) Not all operations call link_path_walk() before these operations
      are done. For example, ftruncate() doesn't call link_path_walk().

  (3) The rename() and link() operations handle two pathnames.
      But, it is not possible to know both pathnames at the moment of
      link_path_walk().

I think we need to introduce new LSM hooks outside link_path_walk().
http://kerneltrap.org/mailarchive/linux-fsdevel/2008/2/17/882024
