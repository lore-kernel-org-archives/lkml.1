Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbXEORpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbXEORpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760133AbXEORpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:45:07 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54712 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbXEORpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:45:03 -0400
Message-ID: <4649F11F.3040807@zytor.com>
Date: Tue, 15 May 2007 10:42:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: select(0, ..) is valid ?
References: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
> Hi,
> 
> Is select(0, ..) is a valid operation ?
> 
> I see that there is no check to prevent this or return
> success early, without doing any work. Do we need one ?
> 
> slub code is complaining that we are doing kmalloc(0).
> 

select(0, ...) is valid, and is functionally equivalent to
select(..., NULL, NULL, NULL, ...); except that any nonzero fdsets get
zeroed on return.  As such, the only thing that can interrupt it is the
timeout, or a signal.

	-hpa
