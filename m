Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbYCFPzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbYCFPzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760335AbYCFPzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:55:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbYCFPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:55:01 -0500
Message-ID: <47D012B4.3020104@zytor.com>
Date: Thu, 06 Mar 2008 07:50:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: NightStrike <nightstrike@gmail.com>, Olivier Galibert <galibert@pobox.com>,
       Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>	 <47CF11D6.7070901@zytor.com>	 <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>	 <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de>	 <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com>	 <47CF3F09.4080606@zytor.com>	 <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com>	 <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org>	 <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com> <6dc9ffc80803060743h502fc96bj6117ef87a8555c3a@mail.gmail.com>
In-Reply-To: <6dc9ffc80803060743h502fc96bj6117ef87a8555c3a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.J. Lu wrote:
> I agree with it. There is no  right or wrong here Let's start from
> scratch and figure out
> what is the best way to handle this, assuming we are defining a new psABI.

No, I believe the right way to approach this is by applying the good 
old-fashioned principle from Ask Mr. Protocol:

	Be liberal in what you receive, conservative in what you send

In other words:

	a. Fix the kernel.  Already in progress.
	b. Do *not* make gcc assume DF is clean for now.  Adding a
	   switch would be a useful thing, since if nothing else it
	   would benefit embedded environments.  We might assume
	   DF is clean on 64 bits, since it appears it is rarely used
	   anyway, and 64 bits is more important in the long run.
	c. Once fixed kernels have been out long enough, we can
	   flip the default of the switch, one platform at a time if
	   need be (e.g. there may never be another SCO OpenServer.)

	-hpa
