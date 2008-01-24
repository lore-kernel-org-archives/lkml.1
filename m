Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYAXEzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYAXEzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 23:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYAXEzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 23:55:40 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:30854 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752982AbYAXEzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 23:55:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=3fjC4Vs0tL4VYk54+d6bQYtlDE2UqvPpeDkvGsbae1NmQAii4UDDFXEU3L8mAXpXBSK14qz3rYy2J0Kxpp3VHqvXHOeHMUPwuMRzH1DOKwo7tZdAAyzlzDoOC7hHeFb1DLTy39foxcCdr//tT48kBeNGbnIcwig1kB/7WFlLsDs=  ;
X-YMail-OSG: 9LT.ttgVM1nRSdmZSBREwcNQYaAAEXKFJFKoCr_C0K0ENBBNrHHNQ9o1QJUTixYT_h.yYqwIG2Q5yGbCpYl0NxWFQJquOr57Iww4
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 3/4] firewire: enforce access order between generation and node ID
Date: Thu, 24 Jan 2008 15:55:30 +1100
User-Agent: KMail/1.9.5
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>,
       Jarod Wilson <jwilson@redhat.com>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de> <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de> <tkrat.f1b275fda9e67a3c@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f1b275fda9e67a3c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801241555.30659.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008 11:54, Stefan Richter wrote:
> fw_device.node_id and fw_device.generation are accessed without mutexes.
> We have to ensure that all readers will get to see node_id updates
> before generation updates.
>
> An earlier incarnation of this patch fixes an inability to recognize
> devices after "giving up on config rom",
> https://bugzilla.redhat.com/show_bug.cgi?id=429950
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> Rework of patches
>     firewire: fw-core: enforce write order when updating
> fw_device.generation and parts of
>     firewire: fw-core: react on bus resets while the config ROM is being
> fetched firewire: fw-sbp2: enforce read order of device generation and node
> ID from November 1 2007.
>
> Update:
>   - write site and read sites folded into one patch
>   - added fix to fw_device_enable_phys_dma() and fill_bus_reset_event()
>   - smp_ barriers are sufficient
>   - comments, changelog

I don't know the firewire subsystem at all, but the barriers seem
right (in that they match your description of the problem), and
comments for them are really good.

Thanks,
Nick
