Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbYB1Ilv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbYB1Ilv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbYB1Ill
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:41:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48951 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYB1Ilk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:41:40 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C673B0.2070705@s5r6.in-berlin.de>
Date: Thu, 28 Feb 2008 09:41:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/2] firewire: endianess fix
References: <20080220220326.GA22328@uranus.ravnborg.org>	<1203545913.25307.47.camel@brick>	<tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>	<tkrat.9e19fa31951506af@s5r6.in-berlin.de> <1204166506.15052.336.camel@pasglop>
In-Reply-To: <1204166506.15052.336.camel@pasglop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Do we have the workaround for the old Apple UniNorth in the new FW OHCI
> driver (for selfID swapping iirc ?)

According to ohci1394.c, it selfIDs and headers of incoming packets are 
not byte-swapped by the old Apple Uninorth FireWire part.  And no, 
firewire-ohci doesn't have the workaround yet.

It should be trivial to copy'n'paste ohci1394's workaround into fw-ohci, 
but it would be good if someone could test before and after.

BTW, since that code is touched everytime a packet is received, we 
should enclose such a workaround in #ifdef CONFIG_PPC_PMAC && 
CONFIG_PPC32, shouldn't we?  (As a second step after adding the workaround.)
-- 
Stefan Richter
-=====-==--- --=- ===--
http://arcgraph.de/sr/
