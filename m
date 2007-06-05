Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbXFEAjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbXFEAjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 20:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbXFEAjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 20:39:40 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:33734 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbXFEAjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 20:39:39 -0400
Date: Mon, 04 Jun 2007 18:38:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC 0/4] CONFIG_STABLE to switch off development checks
In-reply-to: <fa.wiSgrIhkRNkkC7Wh6Bt3BY4z7BM@ifi.uio.no>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Message-id: <4664B076.5000406@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.UBCbBXgIW93M6j2F+d+umQ5+v9I@ifi.uio.no>
 <fa.iaekQW/Par/E6eIpnL0NjEdCUxc@ifi.uio.no>
 <fa.2BlkzuhauAATrsG1MYhPMeWMhPM@ifi.uio.no>
 <fa.o9WA1K75HxwNnBEQDyoQMfWVpiQ@ifi.uio.no>
 <fa.wiSgrIhkRNkkC7Wh6Bt3BY4z7BM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp wrote:
> I'm on Christoph's side here.  I don't think it makes sense for any code
> to ask to allocate zero bytes of memory and expect valid memory to be
> returned.
> 
> Would a compromise be to return a pointer to some known invalid region?
> This way the kmalloc(0) call would appear successful to the caller, but
> any access to the memory would result in an exception.

I would think returning 1 as the address would work here, it's not NULL 
but any access to that page should still oops..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

