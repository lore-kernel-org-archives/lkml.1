Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbZJAOg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbZJAOg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932519AbZJAOg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:36:58 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:64940 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbZJAOg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <20091001141524.GA3355@kroah.com>
References: <Pine.LNX.4.64.0910010950330.4408@axis700.grange> 
	<20091001132709.GA2221@kroah.com> <Pine.LNX.4.64.0910011533220.4408@axis700.grange> 
	<20091001141524.GA3355@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 1 Oct 2009 16:28:31 +0200
Message-ID: <ac3eb2510910010728v33e76f2ev751c20b3e454cf7a@mail.gmail.com>
Subject: Re: [PATCH] drivers-core: nullify private pointer on device-release
To: Greg KH <greg@kroah.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 1, 2009 at 16:15, Greg KH <greg@kroah.com> wrote:
> On Thu, Oct 01, 2009 at 03:45:56PM +0200, Guennadi Liakhovetski wrote:

>> My problem case is the soc-camera framework. There device struct is
>> embedded into the video client object, which are kept as long as the
>> driver is loaded.
>
> struct device is a dynamic structure, it is supposed to be able to be
> freed when the last reference goes away.  Static struct device usage is
> wrong.  It sounds like the video client object code is incorrect, please
> fix it.

Exactly. If you keep your "object" around for forever, you must never
embed a struct device but only a pointer to one that is managed by the
core. Embedding a struct device defers lifetime management of the
enclosing object to the driver core reference counts.

You can not have both, you have to decide to let your objects be
managed by the driver core reference, or just point to a dynamic
driver core object. All driver core objects are always dynamic,
everything else just seem to work, but are not expected to work
reliably.

Thanks,
Kay
