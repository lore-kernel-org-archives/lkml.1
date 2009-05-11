Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZEKNcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZEKNcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZEKNbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:31:50 -0400
Received: from iona.labri.fr ([147.210.8.143]:45022 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZEKNbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:31:50 -0400
Message-ID: <4A0828D1.4040109@inria.fr>
Date: Mon, 11 May 2009 15:32:01 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Stefan Lankes <lankes@lfbs.rwth-aachen.de>, linux-kernel@vger.kernel.org,
       Lee.Schermerhorn@hp.com, linux-numa@vger.kernel.org
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de> <87zldjn597.fsf@basil.nowhere.org>
In-Reply-To: <87zldjn597.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Stefan Lankes <lankes@lfbs.rwth-aachen.de> writes:
>   
>> [Patch 1/4]: Extend the system call madvise with a new parameter
>> MADV_ACCESS_LWP (the same as used in Solaris). The specified memory area
>>     
>
> Linux does NUMA memory policies in mbind(), not madvise()
> Also if there's a new NUMA policy it should be in the standard
> Linux NUMA memory policy frame work, not inventing a new one
>   

Marking a buffer as "migrate-on-next-touch" is very different from
setting a NUMA policy. Migrate-on-next-touch a temporary flag that is
cleared on the next-touch. It's cleared per page, not per area or
whatever. So marking a VMA as "migrate-on-next-touch" doesn't make much
sense since some pages could already have been migrated (and brought
back to their usual state) while some other are still marked as
migrate-on-next-touch.

Brice

