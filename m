Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYAJBm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYAJBm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 20:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYAJBmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 20:42:49 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:22712 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754402AbYAJBms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:42:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4VxXtiXnB6XzxmBYbASQ7XLTnfjkvDgVn4oprJv9C+Qtw+wSCMGiVSG/pSOGvufozyPhvFQTYx0K4Zbt6j0Qyq6fiz17pbvqsBMLaf4kwZImkM5Z/LeZsggyIR6mTPcH5xgcxdJKVdFiifLeQuooJBAVWP1Cv6Uw9zzaGkUdueo=  ;
X-YMail-OSG: JmgMxVMVM1lsECklkiD5eK94I_fRkYOksmcenpAFZDdoVtaiOAsxxnkQA3R1nhbRRQRtky5Zvg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Date: Thu, 10 Jan 2008 12:42:25 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org
References: <20080109085231.GE6650@kernel.dk>
In-Reply-To: <20080109085231.GE6650@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101242.25671.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 19:52, Jens Axboe wrote:

> So how does it work? Instead of punting IO to a thread and passing it
> through the page cache, we instead attempt to send the IO directly to the
> filesystem block that it maps to.

You told Christoph that just using direct-IO from kernel still doesn't
give you the required behaviour... What about queueing the IO directly
*and* using direct-IO? I guess it still has to go through the underlying
filesystem, but that's probably a good thing.

> loop maintains a prio tree of known 
> extents in the file (populated lazily on demand, as needed).

Just a quick question (I haven't looked closely at the code): how come
you are using a prio tree for extents? I don't think they could be
overlapping?
