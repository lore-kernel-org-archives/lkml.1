Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbYD2Mqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbYD2Mqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYD2Mqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:46:44 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:15535 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751732AbYD2Mqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mcSWNXhJwpJDa8dylKYBNToYEaJK7IWOj2/ERjc2uJS0PIarrVXf0TruvYdH3qFjI7EmuRvnwwzSw1aSYiJNRGc085zwZGvqP9jvSqp8RXUndjj4DKNmBXONHgEjDTIcTAUqM0w1eeIOP1ibgXmoKZX3w2yi0gEbRePZBSCveZ0=
Message-ID: <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com>
Date: Tue, 29 Apr 2008 15:46:42 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: sancelot@free.fr
Subject: Re: detecting kernel mem leak
Cc: linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <1209462094.4816ed4e93977@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209462094.4816ed4e93977@imp.free.fr>
X-Google-Sender-Auth: aa03290d08f97061
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:41 PM,  <sancelot@free.fr> wrote:
>  I noticed the memory was growing without doing anything in my system ....after
>  some investigations , it looks like some kernel components may be involved in
>  this problem.
>
>  I would like to know if there is a way to monitor activity of memory (de)alloc
>  of the kernel in order to target which partof the system/kernel could do this..?

You can do

 cat /proc/meminfo | grep Slab

and if that grows too much over time you can do

  cat /proc/slabinfo

or use a tool such as slabtop to see where the memory is going. If the
memory is being leaked in the kmalloc caches, you can use
CONFIG_DEBUG_SLAB_LEAK which part of the kernel is doing all those
allocations (not really suitable for production machines).

Also remember to check that Active + Inactive + Buffers + Cached is
roughly the same size as MemTotal - MemFree; otherwise your kernel
might be leaking full pages.

Christoph, I suppose there's some option to
Documentation/vm/slabinfo.c that provides similar output to
CONFIG_DEBUG_SLAB_LEAK for SLUB?

                                Pekka
