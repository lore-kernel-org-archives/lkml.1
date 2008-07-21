Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYGUCCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYGUCCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 22:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbYGUCCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 22:02:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:4534 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbYGUCCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 22:02:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ATkMhCGXkPFGeW2GlUgcEROWPEqYR/A2MTci3tFYGDq7gWO+kn7Imn0phY6xoKTLAM
         zbRj/aghUcPIKO6IZ0qLpilXPwAvJCqlHNxQD5WuxqiIBVXbVTM8IE4rdoSi1EXe2M1U
         Ahdkwgk4Z0KBMHQ0HBx86Yl4OLFmRsBZ36R+A=
Date: Sun, 20 Jul 2008 21:03:49 -0500
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Suspend to RAM regression (bisected)
Message-ID: <20080721020349.GA4328@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a suspend to RAM regression in the latest Linus tree of
17th of july (5b664cb235e). It was working perfectly with 
2.6.26.

If I suspend to RAM from X with 'echo mem > /sys/power/state' the
screen comes back very dark and I can't read anything.
If I switch to the text console and then go back to X this problem
is fixed and everything is ok.

I bisected this regression down to c0e09200dc0813972442e550a5905a132768e56c
("drm: reorganise drm tree to be more future proof"), and I checked that
reverting this commit (it reverts cleanly) really makes the regression go
away.

The laptop is a Vaio 64bit with Intel GM965/GL960 graphics card.
More information about my laptop can be found here:
http://www.ift.unesp.br/users/crmafra/dmesg-good.txt

