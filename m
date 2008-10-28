Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYJ1WOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYJ1WOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYJ1WOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:14:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:27418 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYJ1WOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:14:34 -0400
Message-ID: <ac3eb2510810281514o5f438746r11000c54ced9edf9@mail.gmail.com>
Date: Tue, 28 Oct 2008 23:14:25 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Sebastian Kuzminsky" <seb@highlab.com>
Subject: Re: getting configuration info into a driver at load-time
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4906499C.8090308@highlab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4906499C.8090308@highlab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 00:07, Sebastian Kuzminsky <seb@highlab.com> wrote:
> Hi folks, i'm looking for a way to pass structured configuration information
> to a device driver at load-time.
>
> I'm working on a device driver for a family of FPGA cards for motion control
> of industrial robots and computer-controlled machine tools.  The driver
> loads the FPGA firmware with request_firmware() and sends it to the FPGA.
>
> Once the FPGA is up and running, the user needs to configure the firmware
> specifically for their machine, by telling the firmware things like "my
> machine has two stepper motors and three servo motors, and the second servo
> motor has an encoder with an index channel".  The details of the information
> being relayed isnt important, the key thing is that it's like a struct
> containing a couple of arrays of different kinds structs, something like
> this:
>
>    struct config {
>
>        struct {
>            bool enabled;
>            bool index_enabled;
>            bool index_mask_enabled;
>        } encoder_config[];
>
>        struct {
>            bool enabled;
>        } pwmgen_config[];
>
>        struct {
>            bool enabled;
>            uint width;
>        } stepgen_config[];
>
>        char *firmware;
>
>        bool enable_raw;
>
>    } board_config;
>
>
> Each board that the driver finds should get its own "board_config".
>
> I thought about exposing this config structure in /sys or /proc (in a
> per-board directory), and let the user poke in the config values after the
> driver has loaded, but I'd really prefer to make the information available
> at load-time.
>
> Currently the driver has a module param array of char*, with each board's
> configuration encoded into an ascii string which gets decoded "by hand" in
> the driver.  Pretty grotty.
>
> Is there some easier/cleaner way to do this?

Maybe configfs?

Kay
