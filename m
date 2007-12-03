Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbXLCFPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbXLCFPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 00:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbXLCFOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 00:14:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:51437 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbXLCFOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 00:14:54 -0500
Message-ID: <47539030.10600@argo.co.il>
Date: Mon, 03 Dec 2007 07:12:16 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Kyle Moffett <mrmacman_g4@mac.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk>	<20071130143445.GA2310@csclub.uwaterloo.ca>	<53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>	<4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de>
In-Reply-To: <p733aukyl8n.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Avi Kivity <avi@argo.co.il> writes:
>   
>> [I really doubt there are that many of these; syscall
>> entry/dispatch/exit, interrupt dispatch, context switch, what else?]
>>     
>
> Networking, block IO, page fault, ... But only the fast paths in these 
> cases. A lot of the kernel is slow path code and could probably
> be written even in an interpreted language without much trouble.
>
>   

Even these (with the exception of the page fault path) are hardly "we 
care about a single instruction" material suggested above.  Even with a 
million packets per second per core (does such a setup actually exist?)  
You have a few thousand cycles per packet.  For block you'd need around 
5,000 disks per core to reach such rates.

The real benefits aren't in keeping close to the metal, but in high 
level optimizations.  Ironically, these are easier when the code is a 
little more abstracted.  You can add quite a lot of instructions if it 
allows you not to do some of the I/O at all.


