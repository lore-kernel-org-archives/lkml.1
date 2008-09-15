Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbYIOUph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbYIOUph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYIOUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:45:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:56973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbYIOUp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:45:27 -0400
Message-ID: <48CEC8F2.4040904@kernel.org>
Date: Mon, 15 Sep 2008 13:43:30 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: XFS shutting down due to IO timeout on SATA disk (pata_via for
 CX700)
References: <20080911193511.7960bc82@neptune.home>	<48CE22E5.9090403@kernel.org> <20080915190242.58d21a8f@neptune.home>
In-Reply-To: <20080915190242.58d21a8f@neptune.home>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Sep 2008 20:44:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bruno Prémont wrote:
> On Mon, 15 September 2008 Tejun Heo <tj@kernel.org> wrote:
>> (please try to wrap paragraphs for 80 column)
> I try not to break lines from dmesg, lspci and and other commands'
> (formatted) output as those tend to get pretty hard to read when
> line-wrapped.  Sorry if I wrapped my text after 80 columns.

Yeap, I was talking only about the text.  Not wrapping outputs and
code snippets is definitely better.

>> Timeout on FLUSH_EXT.  That's a bad sign.  Patch to retry FLUSH is
>> pending but at any rate FLUSH failure is often accompanied by loss of
>> data and XFS is doing the right thing of giving up on it.
>>
>> Can you please post the result of "smartctl -a /dev/sda"?
> I checked it though there were no errors logged nor any other information
> that would catch attention. The disk/machine is pretty unused (a year old
> but low uptime, a few hours those days with uptime)
> 
> Anyhow smaprtctl's output is blow.
> 

>   5 Reallocated_Sector_Ct   0x0033   100   100   024    Pre-fail  Always       -       8589934592000

Whee... That's unusally high realloc count but I'm not sure whether it
indicates actual problem or it's just the drive's way of saying I'm
okay.  But this does look quite suspicious.

> 196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       441778176

Hmmm.. Do you happen to have drives of the same model?  If so, can you
please check what other drives are reporting?

Thanks.

-- 
tejun
