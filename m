Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYHGREx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYHGREx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYHGREm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:04:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34511 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYHGREl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:04:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <489B2B20.2040205@s5r6.in-berlin.de>
Date: Thu, 07 Aug 2008 19:04:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: Andi Kleen <andi@firstfloor.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>    <Pine.LNX.4.64.0808051140150.6309@anakin>    <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>    <200808060133.10457.nickpiggin@yahoo.com.au>    <87r6926dsr.fsf@basil.nowhere.org> <4899DD9F.6020007@windriver.com>    <20080806185719.GE24801@one.firstfloor.org>    <37747.166.70.238.45.1218113134.squirrel@webmail.wolfmountaingroup.com>    <20080807160702.GF24801@one.firstfloor.org> <1913.69.2.248.210.1218124373.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1913.69.2.248.210.1218124373.squirrel@webmail.wolfmountaingroup.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
>>> Also, whoever wrote "/Documentation/volatiles_are_evil" must not have
>>> worked with the busted-ass GNU compiler that optimizes away global
>>> variables and busts SMP dependent code.  I am not going to remove the
>> The Linux way to handle this is to use gcc memory barriers.
>> mb()/barrier()/wmb()/rmb()/smp_rmb()/smp_wmb() etc.
>> Normally everything that volatile can do can be expressed by them.
[...]
>> See Documentation/memory-barriers.txt
[...]
> I'll instrument this as described in the documentation you referenced and
> remove the volatile declarations.  If this passes testing, I will repost
> with these corections.

Take care though that neither memory barriers nor volatile are what you 
want if accesses need to be atomic on whatever given data structure. 
(E.g. bitfield manipulations, counter increments, accesses to virtually 
anything that is bigger than an integer or a pointer...)
-- 
Stefan Richter
-=====-==--- =--- --===
http://arcgraph.de/sr/
