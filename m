Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXGNHKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXGNHKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbXGNHKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:10:13 -0400
Received: from main.gmane.org ([80.91.229.2]:58211 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbXGNHKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:10:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Daniel Mantione <daniel.mantione@freepascal.org>
Subject: Keyboard programming needs root
Date: Sat, 14 Jul 2007 08:32:32 +0200
Message-ID: <f79qnt$rn3$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: mantione.demon.nl
User-Agent: KNode/0.8.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A while back a patch was merged to make that only root can program the
keyboard:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0b360adbdb54d5b98b78d57ba0916bc4b8871968

Is this patch discussable? I think this patch isn't proper because of the
following reasons:

* Users can play games in many ways. They can configure the terminal
  settings, (remove the automatic line feed, disable the echo etc). They can
  load console fonts. They can still put the keyboard in raw mode, etc.
* All of these games can be prevented by making mingetty (or whatever getty
  is used) or PAM can put the console into a known state after logout.
* All of these games are annoyances, system security is not compromised.
* I do not see a problem with for example a French user doing a "loadkeys
  fr" if that allows hims to use the computer easier.

Worst issue for me though, is that KDSBENT is needed to be able to catch
keys like shift+tab, alt+fx, escape without delay. My application suddenly
needs root permissions to work properly. The alternative, semi raw mode,
has the disadvantage that you need to implement your own keymaps (like X).
In short, this change breaks applications.

Daniël Mantione

