Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYAQXVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYAQXVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYAQXVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:21:30 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:14680 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYAQXV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:21:29 -0500
Message-ID: <478FE22D.9030907@emc.com>
Date: Thu, 17 Jan 2008 18:18:05 -0500
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Daniel Phillips <phillips@google.com>,
       Bryan Henderson <hbryan@us.ibm.com>, Al Boldi <a1426z@gawab.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Rik van Riel <riel@redhat.com>, Valerie Henson <val.henson@gmail.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
References: <4d47a5d10801151724m418e18efp9a0dd936e9a3584c@mail.gmail.com> <OFDB679999.9793D1C7-ON882573D2.00646D05-882573D2.0068FF85@us.ibm.com> <4d47a5d10801161802x2c24ef59pf8422c8d14d487aa@mail.gmail.com> <20080117224530.GH5547@mit.edu>
In-Reply-To: <20080117224530.GH5547@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Jan 16, 2008 at 09:02:50PM -0500, Daniel Phillips wrote:
>> Have you observed that in the wild?  A former engineer of a disk drive
>> company suggests to me that the capacitors on the board provide enough
>> power to complete the last sector, even to park the head.
>>

Even if true (which I doubt), this is not implemented.

A modern drive can have 16-32 MB of write cache. Worst case, those 
sectors are not sequential which implies lots of head movement.

> 
> The problem isn't with the disk drive; it's from the DRAM, which tend
> to be much more voltage sensitive than the hard drives --- so it's
> quite likely that you could end up DMA'ing garbage from the memory.
> In fact the fact that the disk drives lasts longer due to capacitors
> on the board, rotational inertia of the platters, etc., is part of the
> problem.

I can tell you directly that when you drop power to a drive, you will 
lose write cache data if the write cache is enabled. With barriers 
enabled, our testing shows that file systems survive power failures 
which routinely caused corruption without them ;-)

ric


