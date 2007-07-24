Return-Path: <linux-kernel-owner+w=401wt.eu-S1762837AbXGXR1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762837AbXGXR1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXGXR11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:27:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:57666 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbXGXR10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ec3Q/SOVIeujn7plLMwLGMADnyxG0SMUQ2HGtVCN6qcB2zw+RzBM0w2CL7z6ai1LLTIOrX1nu6akh8B9uQmZl1m/lSu9dxDcK98svgNDnh6dlXMnTS30DoXJWhgBpu3jClk2DvRYQ/NeXcFe4RlV3bINHUY+dWnqeGk/nxG9em8=
Message-ID: <dda83e780707241027k369c2f01j6d16b21266df3a05@mail.gmail.com>
Date: Tue, 24 Jul 2007 10:27:22 -0700
From: "Bret Towe" <magnade@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc1 regression: mm: fix fault vs invalidate race for linear mappings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

for a while in -git I've had an issue that on boot when gdm loads the
screen stays black
using ctrl-f1 doesn't return to a console and killing X doesn't help any
ssh'ing into the box does work top only shows 100% io-wait
dmesg shows nothing odd

the work around I have is at the moment is to just move the radeon drm module
out of the way so it doesn't load on boot and X works just fine like that
I did some bisecting which took a few days and tracked it down to
commit d00806b183152af6d24f46f0c33f14162ca1262a

its way to complex for me to revert it on top of -rc1 to verify that's
the issue tho
I keep forgetting to get a trace of what its waiting on when I'm in that kernel
I assume that would be of use and Ill get that later

the box this is happening on is a g4 mac mini the built in card is a radeon 9200
I'm not seeing any issues on an amd64 box with radeon card it's also a 9600 tho
