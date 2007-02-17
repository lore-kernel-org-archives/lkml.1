Return-Path: <linux-kernel-owner+w=401wt.eu-S965216AbXBQMKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965216AbXBQMKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 07:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965217AbXBQMKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 07:10:00 -0500
Received: from gockel.physik3.uni-rostock.de ([139.30.44.16]:10923 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965216AbXBQMKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 07:10:00 -0500
Date: Sat, 17 Feb 2007 13:09:58 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: Johann Schuster <johann.schuster@unibw.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Measuring cpu time using getrusage
In-Reply-To: <45D30BDF.5010608@unibw.de>
Message-ID: <Pine.LNX.4.63.0702171302570.20161@gockel.physik3.uni-rostock.de>
References: <45D30BDF.5010608@unibw.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Johann Schuster wrote:

> currently i'm trying to measure the cpu times for
> numerical algorithms written in C using two calls of
> getrusage() and then calculating the time difference.
> 
> According to the man page of getrusage i looked at the
> user time of my process. Surprisingly the measured user
> times vary strongly depending on the system load of the
> machine.
> A heavy system load nearly doubles the measured time
> for my routine.

Does your system have hyperthreading? (look at whether the siblings field 
in /proc/cpuinfo is greater than one)
If yes, there is no way to accurately measure runtimes because the 
(single-threaded) performance of your CPU depends on the other tasks 
running. Just disable hyperthreading for these measurements.

Tim
