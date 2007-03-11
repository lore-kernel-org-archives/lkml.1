Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbXCKEbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbXCKEbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 23:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933055AbXCKEbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 23:31:37 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:38122 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932904AbXCKEbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 23:31:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aeCem4/P4Yi+mrfyFf3mHdUOxHOB+RyaTHC5cXVqH58AdhL0LoZ8u7rLJZR4y8BS8+GJbD0AhCfobsArxqwiL7O9wDNEcvNc17E+N+FMLT90WUkV4JBxqVf3FZ/9fxPyVuQkZjd+fJlUY7hhlMPqjh6hqxasyJtA6Rio4UqUN74=  ;
X-YMail-OSG: L3JLn.0VM1l4FmK7JS3W_pH.UbLMFzJcEbf5j.HXjuZYcU2xAxESeemPAWkZQZK5Rt3pM6oONBY7pnJq1iucVSqabp1xaZlioaOU_Syzv9GHJaTJCkH7abO9HlNE6CLMDAmyipjRHi.3b_4-
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH v2] Bitbanging i2c bus driver using the GPIO API
Date: Sat, 10 Mar 2007 20:02:20 -0800
User-Agent: KMail/1.7.1
Cc: Jean Delvare <khali@linux-fr.org>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
References: <200703091345.44744.david-b@pacbell.net> <11735324081261-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <11735324081261-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703102002.21771.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 5:13 am, Haavard Skinnemoen wrote:
> This is a very simple bitbanging i2c bus driver utilizing the new
> arch-neutral GPIO API. ...
> ---
> This patch is different from the first patch in the following ways:
>   * Handles pins set up as open drain (aka multidrive) by toggling
>     the output value instead of the direction
>   * Handles output-only SCL pins the same way, and also does not
>     install a getscl() callback for such pins
>   * Does not add anything to include/linux/i2c-ids.h
>   * Sets the output value explicitly after changing the direction to
>     output.
>   * Plugs a memory leak in remove() -- algo_data wasn't freed.
>   * Prints out the pin IDs in decimal, with an extra note when clock
>     stretching isn't supported
> 
> This version has been compile-tested only. I'll give it a spin when I
> get back to work on monday.
> 
> Dave, does this address your concerns?

Yes, though see my followup to Jean's note.  Unless I make time
to test this out on some system, the issues seem to be:

 (a) will need to change once gpio_direction_output() gains
     that second argument;

 (b) i2c-gpio.h could stand one minor comment addition to highlight
     an assumption.

Looking good!

- Dave
