Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832AbZIHRAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbZIHRAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZIHRAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:00:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbZIHRAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:00:53 -0400
Date: Tue, 8 Sep 2009 10:00:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: reinette chatre <reinette.chatre@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug #13819] system freeze when switching to console
In-Reply-To: <1252427375.14735.130.camel@rc-desk>
Message-ID: <alpine.LFD.2.01.0909080943030.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>  <Vm51Upp4EV.A.r-D.mgBpKB@chimera> <1252427375.14735.130.camel@rc-desk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Sep 2009, reinette chatre wrote:

> On Sun, 2009-09-06 at 10:24 -0700, Rafael J. Wysocki wrote:
> > Please verify if it still should be listed and let me know
> > (either way).
> 
> Issue is still present in 2.6.31-rc8.

Is there any chance that you could connect a serial line to the machine? 
Your report about blinking keyboard led's means that there's an oops, but 
since the display isn't in textmode (and the oops obviously happens when 
trying to enter it), we don't know what it is.

A serial line (along with a kernel compiled with serial console support, 
of course, and a kernel command line option like "console=ttyS0,115400 
console=tty0") would get that. You'd just need another machine with a 
terminal program like minicom..

The network console could also work out, but serial lines tend to be more 
reliable if you have them. But in the absense of serial lines, see the
Documentation/networking/netconsole.txt file for some details. The setup 
is more complicated, but on the other hand it's a lot more dynamic, and in 
your case - since the box works until you try to switch to text-mode, I 
suspect the network console dynamic run-time setup would be easy for you 
to use.

(For other examples of using netconsole with that dynamic mode, just 
google for "sys/kernel/config/netconsole" and you'll find a number of docs 
that explain how to find the MAC address for setup etc).

		Linus
