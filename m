Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbZABKZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbZABKZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZABKZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:25:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:54670 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZABKZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qhn/ok8cnSD0cHCsPsvhU/XSM/nGQu8utPjF1eybEMnXI9dNeYZRgERkAOJnG6lGvi
         yC3qR6BONogOWymnyQBz4s1GvEAZp4HDagPJ5G86sY9VItL8I7HA02PDqqqyPIhOlAID
         nw9y5jr/PePvdVYc2C7uPuA0WTaD0gnrVSUWw=
Date: Fri, 2 Jan 2009 13:25:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Len Brown <lenb@kernel.org>
Subject: Re: [patch 3/3] acpi: check for pxm_to_node_map overflow
Message-ID: <20090102102522.GA13629@localhost>
References: <20090102082717.810810508@gmail.com>> <495dd169.0437560a.1cd3.ffffd503@mx.google.com> <20090102092330.GB1975@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102092330.GB1975@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Jan 02, 2009 at 10:23:30AM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > It is hardly (if ever) possible but in case of broken _PXM
| > entry we could reach out of pxm_to_node_map array
| > bounds in acpi_map_pxm_to_node() call. Lets check it
| > (it's not that expensive and safe).
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > CC: Len Brown <lenb@kernel.org>
| > ---
| >  drivers/acpi/numa.c |    2 +-
| >  1 file changed, 1 insertion(+), 1 deletion(-)
| 
| just curious - how did you find this - code review or some tool help like 
| Sparse output or a compiler warning?
| 
| 	Ingo
| 

Unfortunately -- by reading the code :( I would prefer
if gcc or sparse complain about it but we have indirect
referring which is that hard to trace by any tool I believe
(until say some emulator but even if we have such kind of
tool we would need to tell it that 'there we have boundries
we shouldn't cross)'. But to be fair -- I didn't try sparse
here maybe it does complain :)

		- Cyrill -
