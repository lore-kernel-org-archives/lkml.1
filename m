Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbZD1IJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbZD1IJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbZD1IIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:08:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:33513 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZD1IIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:08:48 -0400
Date: Tue, 28 Apr 2009 10:08:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael E Brown <Michael_E_Brown@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Class device namespaces
Message-ID: <20090428100830.1a5d944c@hyperion.delvare>
In-Reply-To: <ac3eb2510904271457w30aac8f5j9ee0d6508f8444c1@mail.gmail.com>
References: <20090329174836.6de797d6@hyperion.delvare>
	<ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	<20090330104952.26f03c13@hyperion.delvare>
	<ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
	<20090426085401.3788fc9c@hyperion.delvare>
	<ac3eb2510904260642s66a15a8eg5811fdc6b339d493@mail.gmail.com>
	<20090427180036.269a40b3@hyperion.delvare>
	<ac3eb2510904271457w30aac8f5j9ee0d6508f8444c1@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

On Mon, 27 Apr 2009 23:57:40 +0200, Kay Sievers wrote:
> On Mon, Apr 27, 2009 at 18:00, Jean Delvare <khali@linux-fr.org> wrote:
> 
> > I'd like to give a try to converting i2c-adapter devices to bus devices
> > rather than class devices, if you think that's how things should be.
> > Can you please explain to me how this would be done?
> 
> Register a "i2c" bus_type with the core, and instead of assigning
> dev.class = class, you assign dev.bus = bus to the devices you
> register, that should work, if there is nothing more complicated going
> on in the background.

Err, I'm confused. We _already_ have an "i2c" bus type, and we already
assign dev.bus = &i2c_bus_type, but for i2c devices (or slaves if you
prefer), not adapters (masters). Doing the same for adapters (the
parents) and devices (the children) looks totally wrong to me.

Are you really certain that i2c-adapters should be bus devices rather
than class devices?

-- 
Jean Delvare
