Return-Path: <linux-kernel-owner+w=401wt.eu-S965180AbXDKVEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180AbXDKVEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 17:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965194AbXDKVEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 17:04:54 -0400
Received: from Apollo.christiedigital.com ([65.195.57.9]:30883 "EHLO
	CDSCYPEXG01.cds.int" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965180AbXDKVEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 17:04:53 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: tmpfs and the OOM killer
Date: Wed, 11 Apr 2007 17:05:06 -0400
Message-ID: <AD98412A5373CC4AA643D9C021922A541C4DD6@cdskitexg01.cds.int>
In-Reply-To: <20070411194820.GI943@1wt.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: tmpfs and the OOM killer
Thread-Index: Acd8cqpdnRHiK030Qb2jern9H5tKngACkVxA
From: "Mouawad, Tony" <Tony.Mouawad@christiedigital.com>
To: "Willy Tarreau" <w@1wt.eu>, "Pedro" <linux_user@izecksohn.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Apr 2007 21:05:08.0546 (UTC) FILETIME=[1603EA20:01C77C7D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone describe the process of finding the best value to tune the
overcommit_ratio to?

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Willy Tarreau
Sent: Wednesday, April 11, 2007 3:48 PM
To: Pedro
Cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer

On Wed, Apr 11, 2007 at 02:23:31AM -0300, Pedro wrote:
>   After suffering some days from a not|mis configured tmpfs,
> 
>   As the OOM killer is not Posix,
> 
>   Better than to kill processes would be to resize tmpfs, to use tmpfs
empty 
> space.

Will not work, because tmpfs does not use any memory for unused space.
If
you don't believe me, simply create a large file on your tmpfs, then
check
free memory, then remove the file and check free memory again.

So your problem is not caused by the empty space on tmpfs, but either by
too much space used on tmpfs or by your application using too much
memory.

>   I'm using kernel 2.6.20.4. If someone ask I'll send a test
application.

Not needed, the one-liner "main(){while(malloc(4096));}" is enough to
trigger an OOM.

If you cannot control your application's memory usage, you'll have to
finely
tune the overcommit_ratio.

Regards,
Willy

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
