Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYGWSLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYGWSLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYGWSLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:11:03 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:46403 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbYGWSLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:11:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=mDyg4tbLzSI1X3NX94yqYSEGb0McwGAUNN9aMHO/rscjfbvXiNN7cBr8VpL83CfZWf
         1vTZHZikr1Bew4ahWgu4D5LqD+tl3R2GlIdCtnIniX0pIvy4LstEBB1bnSC8lClmUc/h
         TgX7iKIvYKBI4MasIBkABtEpOMnA1hSpKtyOs=
Message-ID: <f19298770807231111p2aaa2a3eyc4bf0c084c626c9b@mail.gmail.com>
Date: Wed, 23 Jul 2008 22:11:00 +0400
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: commit a352def21a642133758b868c71bee12ab34ad5c5 broke pptp.
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.


Pptp brakes for me on the current git (c010b2f76):

root@nx:~# pppd call semunlim defaultroute nodetach debug
Couldn't set tty to PPP discipline: Invalid argument
Waiting for 1 child processes...
  script pptp 172.18.2.2 --nolaunchpppd, pid 4359
root@nx:~#

It bisects to:
a352def21a642133758b868c71bee12ab34ad5c5 tty: Ldisc revamp

Revetring this commit, along with
7a4d29f426f17479395980ded8fa5e3bdd6d94e4
and 01e1abb2c27e43339b8829a2e3b1c6f53806b77a fixes the problem.
