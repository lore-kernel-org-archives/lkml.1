Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0BNRzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:55:00 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40828 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0BNRy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:54:59 -0500
Date: Sun, 14 Feb 2010 12:54:45 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>
Subject: Re: oops in uevent_helper [was: mmotm 2010-01-13-12-17 uploaded]
Message-ID: <20100214175445.GA1984@localhost.localdomain>
References: <4B50C2FA.4020100@gmail.com>
 <4B50FC78.9010107@gmail.com>
 <20100122155237.e93a1c55.akpm@linux-foundation.org>
 <4B730EE3.4080405@gmail.com>
 <20100211205745.GA18202@basil.fritz.box>
 <20100211142513.b1fd6e7a.akpm@linux-foundation.org>
 <20100212052126.GA21783@one.firstfloor.org>
 <20100211212708.aa5bec1f.akpm@linux-foundation.org>
 <20100212170624.GB27303@hmsreliant.think-freely.org>
 <4B7833A4.90905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7833A4.90905@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 06:32:20PM +0100, Jiri Slaby wrote:
> On 02/12/2010 06:06 PM, Neil Horman wrote:
> > Fix up remaining references to uevent_helper to play nice with Andi's
> > uevent_helper/rcu changes.
> > 
> > Some changes were made recently which modified uevent_helper to be an rcu
> > protected pointer, rather than a static char array.  This has led to a few
> > missed points in which the sysfs path still assumed that:
> > 1) the uevent_helper symbol could still be accessed safely without
> > rcu_dereference
> > 2) that the sysfs path could copy data to that pointer safely.
> > 
> > I've fixed this by chaging the sysfs path so that it duplicates the string on
> > uevent_helper_store, and freeing it (only if it doesn't point to the
> > CONFIG_DEFAULT_UEVENT_HELPER string), in a call_rcu post-quiescent point.  I've
> > also fixed up the remaining references to the uevent_helper pointers to use
> > rcu_dereference.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Tested-by: Jiri Slaby <jirislaby@gmail.com>
> 
Thanks Jiri!
Neil

> -- 
> js
> 
