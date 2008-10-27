Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbYJ0XH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbYJ0XH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYJ0XHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:07:17 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:37107 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbYJ0XHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:07:15 -0400
X-Authority-Analysis: v=1.0 c=1 a=XbTT8hfkLRMA:10 a=ovsafAsP9nsA:10
 a=jq4HFFTaj3SNji0HdMYA:9 a=JyJ8LPJuupIpQdHuMnul1gOFugQA:4 a=50e4U0PicR4A:10
Message-ID: <4906499C.8090308@highlab.com>
Date: Mon, 27 Oct 2008 17:07:08 -0600
From: Sebastian Kuzminsky <seb@highlab.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: getting configuration info into a driver at load-time
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks, i'm looking for a way to pass structured configuration 
information to a device driver at load-time.

I'm working on a device driver for a family of FPGA cards for motion 
control of industrial robots and computer-controlled machine tools.  The 
driver loads the FPGA firmware with request_firmware() and sends it to 
the FPGA.

Once the FPGA is up and running, the user needs to configure the 
firmware specifically for their machine, by telling the firmware things 
like "my machine has two stepper motors and three servo motors, and the 
second servo motor has an encoder with an index channel".  The details 
of the information being relayed isnt important, the key thing is that 
it's like a struct containing a couple of arrays of different kinds 
structs, something like this:

     struct config {

         struct {
             bool enabled;
             bool index_enabled;
             bool index_mask_enabled;
         } encoder_config[];

         struct {
             bool enabled;
         } pwmgen_config[];

         struct {
             bool enabled;
             uint width;
         } stepgen_config[];

         char *firmware;

         bool enable_raw;

     } board_config;


Each board that the driver finds should get its own "board_config".

I thought about exposing this config structure in /sys or /proc (in a 
per-board directory), and let the user poke in the config values after 
the driver has loaded, but I'd really prefer to make the information 
available at load-time.

Currently the driver has a module param array of char*, with each 
board's configuration encoded into an ascii string which gets decoded 
"by hand" in the driver.  Pretty grotty.

Is there some easier/cleaner way to do this?

-- 
Sebastian Kuzminsky
what i like best about 12648430 is the coffee
