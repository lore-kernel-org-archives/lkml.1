Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbXIEMZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbXIEMZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbXIEMZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:25:10 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:11321 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbXIEMZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EJPySU4vr5ZcpU6yYLItaO72fwPFVSgzJ6R4yttA+/bsJ/pfVv/vcUnjwXzpk4MhIDzd00Fhw1kr7oqxSUJrSOX8e/Y62/1T8r3H3Jr1Mak1z3oU9xXLO052dJQtzVCof4pz3cKAmGL7LYeFjz9emmofrt3wBTmuO1++opgsYZM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [RFC][PATCH] /proc/<pid>/pmaps - memory maps in granularity of pages
Date: Wed, 5 Sep 2007 13:24:59 +0100
User-Agent: KMail/1.9.1
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
References: <20070814085204.GA10884@mail.ustc.edu.cn> <20070814162618.GV30556@waste.org>
In-Reply-To: <20070814162618.GV30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709051324.59283.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2007 17:26, Matt Mackall wrote:
> On Tue, Aug 14, 2007 at 04:52:04PM +0800, Fengguang Wu wrote:
> > Here is a sample output:
> > 
> > # cat /proc/$$/pmaps
> > 080c9000-080f6000 rwxp 080c9000 00:00 0                                  [heap]
> > 32969   45      Y_A_P__ 1
...
> > f7de1000-f7de3000 rwxp 00011000 03:00 176630                             /lib/libnsl-2.3.6.so
> > 17      2       Y_A_P__ 1
> > [...]
> 
> That's a _lot_ of data to generate and parse. I doubt we can watch a
> larger app in realtime with this interface. And it doesn't give us
> physical page numbers either.


> > 080c9000-080f6000 rwxp 080c9000 00:00 0                                  [heap]
> > 32969   45      Y_A_P__ 1
    ^^^^^   ^^
> > f7dba000-f7dc3000 r-xp 00000000 03:00 176633                             /lib/libnss_files-2.3.6.so
                                    ^^ ^^ ^^^^^^

Since it's a new /proc file, we are not bound by compatibility.

Export *all* numbers in hex, and ensure that they are always even-chars wide
("fff" bad, "0fff" good). This way you can do binary<->string conversions
(both in kernel and in userspace) 8 bits per CPU cycle, or even faster.
--
vda
