Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbYENNKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbYENNKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762671AbYENNKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:10:05 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:52463 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762665AbYENNKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:10:04 -0400
Date: Wed, 14 May 2008 15:07:42 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Glauber Costa <gcosta@redhat.com>
Subject: 2.6.26-rc1 sound regression
Message-ID: <20080514130742.GA28872@erig.dyndns.org>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Glauber Costa <gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my sound stops working with 2.6.26-rc1,
alsaplayer makes intermitted random noise.
Bisecting worked fine and the last steps were:

$ git bisect good
Bisecting: 9 revisions left to test after this
[71848d687e2a477cb7c68a854d8fdeaa5dff0ffc] x86: remove virt_to_bus in pci-dma_64.c

$ git bisect good
Bisecting: 4 revisions left to test after this
[8f19ca1341a6d89bd96e2e69e6e10f46d3258089] x86: unify gfp masks

$ git bisect bad
Bisecting: 2 revisions left to test after this
[45a07e774950ef479f8996c0e2c5550dd6440453] x86: use a fallback dev for i386

$ git bisect good
Bisecting: 1 revisions left to test after this
[5fa78ca75d8e67063948a01b51594a0904af5710] x86: retry allocation if failed

The last kernel is bad.
Checked 2.6.26-rc2 too which is bad.

This is a 10+x year old laptop, but it does useful work for me.
The driver is snd_sb8.

Wolfgang
