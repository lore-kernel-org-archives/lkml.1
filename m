Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZAJJab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZAJJab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 04:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZAJJaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 04:30:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53884 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZAJJaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 04:30:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49686A9E.8090808@s5r6.in-berlin.de>
Date: Sat, 10 Jan 2009 10:30:06 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Query about DMA map API implementation in non-coherent archs
References: <9f4f8abe0901091045k4a06e2c9v29a7e8a7387e7a48@mail.gmail.com>
In-Reply-To: <9f4f8abe0901091045k4a06e2c9v29a7e8a7387e7a48@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet Gupta wrote:
...
> As per dma-mapping and dma-api docs, for streaming DMA mappings arch
> needs to provide 2 seperate APIs
> 
> 1. map API to convert cpu address into DMA address
> 2. sync API to flush/invalidate the dcaches for non-coherent archs
> (essentially when changing the ownership of buffer between cpu and
> device).
> 
> However from what I understood, the map API need not take care of
> proper cache sync.However both ARM and MIPS do the cache sync
> operations in map API as well (this is done standalone in sync APIs
> too). Is there a specific reason for this.
> 
> Drivers such as libata don't even call any sync API. For e.g. libata
> only calls dma_map_sg ( ) while setting up the DMA.
...

dma_map_*() transfers ownership of a buffer from CPUs to the device too.
 In case of DMA_TO_DEVICE or DMA_BIDIRECTIONAL, these calls therefore
have to make sure that the device sees current buffer contents.
-- 
Stefan Richter
-=====-==--= ---= -=-=-
http://arcgraph.de/sr/
