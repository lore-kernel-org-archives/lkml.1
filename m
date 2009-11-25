Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZKYO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZKYO7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbZKYO7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:59:19 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:63326 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZKYO7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:59:19 -0500
To: serue@us.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add recursive directory matching operatorsupport.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200911242200.AFC90128.FFJtHLOFVMQSOO@I-love.SAKURA.ne.jp>
	<20091125140009.GA602@us.ibm.com>
In-Reply-To: <20091125140009.GA602@us.ibm.com>
Message-Id: <200911252359.DFI56759.FMOSVOFQFJLHOt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 25 Nov 2009 23:59:21 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> Are you sure you want to use this syntax for 'in_repeating'?

Yes.

I don't have a plan to implement conventional regular expressions.
There are many variants for regular expressions (e.g. shell, perl, sed) and
users likely use characters with special meaning without knowing.
TOMOYO treats a character as literal unless prefixed by '\' character so that
users who didn't know the meaning of a character don't get unwanted results.

> As a unix admin, I expect something like
> 
> 	/{bin,sbin}/init
> (or more likely /{s,}bin/init )
> 
> to mean match both /bin/init and /sbin/init.

You will be able to use

  path_group ALL_INIT /bin/init
  path_group ALL_INIT /sbin/init

    +

  allow_execute @ALL_INIT

in the future (hopefully in Linux 2.6.34).
