Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZBTDAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZBTDAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZBTDAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:00:39 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42266 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256AbZBTDAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:00:38 -0500
X-Sasl-enc: cb78EOswypg7EVBfm4S7IAi/ysgisgghIDn7rcXdAXHs 1235098836
Date: Fri, 20 Feb 2009 00:00:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alexandre Rostovtsev <tetromino@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lenovo-sl-laptop : driver for review
Message-ID: <20090220030033.GA18425@khazad-dum.debian.net>
References: <20090216025918.66d7a466@leftboat.lan> <20090216151809.GA4724@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216151809.GA4724@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009, Matthew Garrett wrote:
> On Mon, Feb 16, 2009 at 02:59:18AM -0500, Alexandre Rostovtsev wrote:
> > +static struct device_attribute dev_attr_bluetooth_enable =
> > +	__ATTR(bluetooth_enable, S_IWUSR | S_IRUGO,
> > +		bluetooth_enable_show, bluetooth_enable_store);
> 
> You support rfkill, so I'm not sure there's a benefit in exposing the 
> same functionality via a custom sysfs node.

Not only there is no benefit, it won't work at all.  The rfkill core will
set the radio state to match the global state for that radio type during the
rfkill_register() call.

Alexandre,  if the thinkpad-sl can store rfkill state across shutdown in
nvram or something like that, there is an API on the rfkill core that you
can use.  The current thinkpad-acpi code does it, you can use that as an
example.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
