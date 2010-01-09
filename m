Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440Ab0AIS5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab0AIS5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 13:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309Ab0AIS5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 13:57:52 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:44328 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0AIS5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 13:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tGaOTIWvlSnvS3q7otXRNuhLjNU86TklNAtIwq2cakv84JC9blP5+C9HedHCCRxF62
         PbcRbLgn5ZuBLejpIeJWtfASp1B4J2R1QdczZnWKMdPjIaqfN34s0Qm9Cjk1EgydDxN4
         0hn0FpkhxdLjvlSOaaHDKi7LLPH0doTNYVXZ8=
MIME-Version: 1.0
Date: Sat, 9 Jan 2010 10:57:48 -0800
Message-ID: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
Subject: Linux Serial Performance
From: "Paul G. Allen" <pgallen@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been working on an application for work written in Java. It's a
production system used for loading firmware into embedded devices via
RS-232. It is designed to load multiple devices in parallel (tested
with up to 32 on a machine thus far). With another Java application
running on Windows XP, a single unit would take about 1 min to load
~400,000 byte binary image. I ported this code to the production
system on Linux and it took over 15 min to load a single unit.

I ran some tests on Windows XP and Linux CentOS 5.1 using the Sun
NetBeans IDE 6.7.1 profiler. The same Java code on both Linux and XP
machines, the same model of machine (Dell, Pentium 4 3GHz, 2.5GB
memory). I am using the Sun comm API currently, and previously I was
using the Serlio API. In all cases, the profiler shows the serial Tx
to be about 20x faster (twenty times) on Windows XP than in Linux. It
takes Linux several seconds to Tx 1024 byte blocks of data over the
serial port where Windows XP takes a fraction of a second. I had also
noticed that Linux seemed to be very slow in 2006-2007 when using
Fedora (can't recall which version) and the Serialio API, but at that
time I could not get Windows to work at all. This has forced us to
lean toward the use of Windows (and pay for licensing for multiple
machines, etc.) instead of Linux for every system that will be used in
testing and manufacture of our product.

I am wondering, have there been any performance tests comparing Linux
serial IO to Windows and what was the result? Is it a problem in the
comm API (e.g. - the Windows DLL having better performance than the
Linux .so)? Is it a problem in the Linux serial driver itself? Is
there something I can/need to do on Linux to tweak the driver and make
it faster?

Thanks,

PGA
-- 
Paul G. Allen
Random Logic Consulting
www.randomlogic.net
