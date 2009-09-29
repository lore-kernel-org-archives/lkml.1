Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbZI2RDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbZI2RDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZI2RDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:03:44 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:48531 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZI2RDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:03:43 -0400
Subject: Re: [PATCH 2.6.33] regulator: Implement WM831x BuckWise DC-DC
 convertor DVS support
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090924183814.GA19474@sortiz.org>
References: <1253634431-8260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1253816876.11624.891.camel@vega>  <20090924183814.GA19474@sortiz.org>
Content-Type: text/plain
Date: Tue, 29 Sep 2009 18:03:42 +0100
Message-Id: <1254243822.6623.313.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 20:38 +0200, Samuel Ortiz wrote:
> On Thu, Sep 24, 2009 at 07:27:56PM +0100, Liam Girdwood wrote:
> > On Tue, 2009-09-22 at 08:47 -0700, Mark Brown wrote:
> > > The BuckWise DC-DC convertors in WM831x devices support switching to
> > > a second output voltage using the logic level on one of the device
> > > pins. This is intended to allow rapid voltage switching for uses like
> > > cpufreq, replacing the I2C or SPI write used to configure the voltage
> > > of the regulator with a much faster GPIO status change.
> > > 
> > > This is implemented by keeping the DVS voltage configured as the
> > > maximum voltage permitted for the regulator. If a request is made
> > > for the maximum voltage then the GPIO is used to switch to the DVS
> > > voltage, otherwise the normal ON voltage is updated and used. This
> > > follows the idiom used by most cpufreq drivers, which drop the
> > > minimum voltage as the core frequency is dropped but use a constant
> > > maximum - raising the voltage should normally be fast, but lowering
> > > it may be slower.
> > > 
> > > Configuration of the DVS MFP on the device should be done externally,
> > > for example via OTP.
> > > 
> > > Support is present in the hardware for monitoring the status of the
> > > transition using a second GPIO. This is not currently implemented
> > > but platform data is provided for it - the driver currently assumes
> > > that the device will be configured to transition immediately - but
> > > platform data is provided to reduce merge issues once it is.
> > > 
> > > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > ---
> > >  drivers/regulator/wm831x-dcdc.c  |  207 ++++++++++++++++++++++++++++++++++----
> > >  include/linux/mfd/wm831x/pdata.h |   17 +++
> > >  2 files changed, 206 insertions(+), 18 deletions(-)
> > > 
> > 
> > Looks good to me.
> > 
> > Samuel, are you ok with the pdata.h change going through regulator ?
> Yes, sure. Feel free to add my Acked-by if needed.

Applied.

Thanks

Liam

