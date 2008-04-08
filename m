Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbYDHGWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbYDHGWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 02:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYDHGV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 02:21:57 -0400
Received: from relay.gothnet.se ([82.193.160.251]:2823 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751170AbYDHGV4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 02:21:56 -0400
Message-ID: <47FB0EE8.30001@tungstengraphics.com>
Date: Tue, 08 Apr 2008 08:21:28 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <200804071259.19743.jbarnes@virtuousgeek.org> <47FA8826.2060802@tungstengraphics.com> <200804071404.28691.jbarnes@virtuousgeek.org>
In-Reply-To: <200804071404.28691.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, April 07, 2008 1:46 pm Thomas Hellström wrote:
>   
>>> Why would we need to flush at all at unbind-read-bind time?  We should be
>>> able to leave pages in the WC state even when we unbind them, then when
>>> we need to bind them back into the GTT they'll be ready, but maybe I'm
>>> misunderstanding you here...
>>>       
>> We want to make the user-space mapping cache-coherent after unbind
>> during read, to have any serious read-speed, and the linear kernel map
>> has to follow, unless it's non-present. Even if it's non present, we
>> need to flush whatever was written through the user-space mapping from
>> the cache when rebinding. Having the user-space mapping read-only when
>> possible will help avoid this.
>>     
>
> Ah, you actually want to *read* from memory?  Yeah that would be really slow 
> if we left it UC or WC.  But I thought that was really only necessary for 
> relocation, and keithp dealt with that with the "presumed offset" stuff?  Are 
> you seeing other cases where we need to read back frequently?
>   
While keithp's "presumed offset" is really good stuff, we should never 
need to read from device memory during relocations, I think. I was 
thinking of EXA and OpenGL software fallback cases, "download from 
screen" and "readpixels" types of operation, as well as 
pixel-buffer-object map in read mode.

/Thomas



