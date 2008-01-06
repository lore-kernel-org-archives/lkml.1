Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYAFLbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYAFLbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 06:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYAFLbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 06:31:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42537 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYAFLbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 06:31:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780BBAA.7020908@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 12:29:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist>
In-Reply-To: <20080106005807.GH22232@does.not.exist>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Jan 06, 2008 at 01:35:21AM +0100, Stefan Richter wrote:
>> instead work on better UIs if you have got
>> trouble with the complexities of the dependencies graph.  The graphic
>> UIs including menuconfig currently work best for tree-like dependencies,
>> but the graph isn't a tree.  Think about how to present this properly in
>> an UI.  The Kconfig files are the wrong place to attack this problem.
>> ...
> 
> Duplicating the structure in each UI should be an improvement?
> 
> Hardly.

What do you mean?

We have dependency data in the Kconfig files.  We have a few different
UIs to them.  Why there are different UIs is easy (oldconfig vs.
xconfig) or not so easy (gconfig vs. xconfig) to explain.  Anyway; IMO
we should keep data and presentation separate for at least two reasons:
  - to allow us to have specialized task-oriented UIs (oldconfig,
    randconfig et cetera)
  - because different people have different approaches to kernel
    configuration (the guy who sets up a new box vs. the guy who bought
    a new gadget vs. the guy who updates his kernel vs. the control
    freak vs. the kernel tester vs...)

If the UIs worked properly, then you won't need separate keywords for
dependency and reverse dependency (depends on vs. select) in the Kconfig
files.

Besides, as Sam has reminded us, the make xyzconfig programs handle the
reverse dependency (select) not correctly yet.  They switch on the
selected symbols without caring whether these symbols have dependencies
themselves.  Friends of 'select', why don't you fix this bug before you
continue to post patches which select symbols which themselves have
dependencies?
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
