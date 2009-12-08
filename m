Return-Path: <linux-kernel-owner+w=401wt.eu-S965373AbZLHBNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373AbZLHBNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbZLHBNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:13:17 -0500
Received: from twilight.fidra.de ([88.198.14.164]:50425 "EHLO
	twilight.fidra.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965364AbZLHBNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:13:17 -0500
From: Volker Lanz <vl@fidra.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes after I/O
Date: Tue, 8 Dec 2009 02:13:20 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.31-rc9-00019-geaa959d; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
References: <200912071856.48125.vl@fidra.de> <200912072136.40202.vl@fidra.de> <4B1D8A27.6050008@kernel.org>
In-Reply-To: <4B1D8A27.6050008@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912080213.20502.vl@fidra.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009 00:05:11 Yinghai Lu wrote:
> the updated e820 table is the same to the one for 2.6.29...
> 
> so could be some other patch cause the problem.
> 
> please check if revert
> 2547089ca2db132e307ef68848ba029a8ec2f341
> could help.

I reverted to one commit before that, which would be 
eaa959df299157e2640fcb3321537501b6afd9e6
if I am not mistaken. I built and booted that kernel and could reproduce the 
freeze with it (TBH this was not surprising to me, because I originally pinned 
down the problem by bisecting the commits and this commit is after the one 
bisecting found. Am I missing a detail here?)

But strangely enough the freeze this time produced an oops before it locked 
the machine. I couldn't save it to a file but took a picture. The screenshot 
is here:
http://banane.volker-lanz.de/08122009013.jpg
The oops is _not _reproducable. After a reboot with this same kernel, a 
suspend/resume cycle and some I/O the machine locks again without showing the 
oops.

Volker
