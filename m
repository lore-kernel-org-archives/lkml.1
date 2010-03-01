Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab0CAONQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:13:16 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59697 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0CAONO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L89+41RzsG5ktGHBvzoWLzfapinJFXp477gtXYuV+4k7LnsUxVDnv9XHTjXIK/Oa+9
         pWR53C0Z7iY1KKQpRJkggMRk0FflBJW+jfmpR+gh/NiEl8GDG2P0c8Bd+0GInbHMx460
         Zpm/BfZeMaocvjIu3kqIzcDpfeXysIN/Kt4UA=
MIME-Version: 1.0
In-Reply-To: <1267446264-8446-1-git-send-email-l.fu@pengutronix.de>
References: <1267446264-8446-1-git-send-email-l.fu@pengutronix.de>
Date: Mon, 1 Mar 2010 15:13:12 +0100
Message-ID: <acd2a5931003010613v4b0f7666ua47e19d72921c151@mail.gmail.com>
Subject: Re: [PATCH] i2c-pnx: fix setting start/stop condition
From: Vitaly Wool <vitalywool@gmail.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
       Kevin Wells <kevin.wells@nxp.com>, Julia Lawall <julia@diku.dk>,
       Russell King <rmk+kernel@arm.linux.org.uk>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 1:24 PM, Luotao Fu <l.fu@pengutronix.de> wrote:
> The start/stop condtions are set in different places repetedly in the i2c-pnx
> driver.  Beside in i2c_pnx_start and i2c_pnx_stop the start/stop bit are also
> set during the transfer of a i2c message in the master_xmit/rcv calls. This is
> wrong since we can't set the start/stop condition during the transaction of a
> single message any way. As a matter of fact, the driver will sometimes set both
> the start and the stop bits at one time. This can be easily reproduced by
> sending a simple read request like e.g
> struct i2c_msg msgs[] = {
> { addr, 0, 1, buf },
> { addr, I2C_M_RD, offset, buf }
> };
> While processing the first message the i2c_pnx_master_xmit will set both the
> start_bit and the stop_bit, which will eventually confuse the slave.
>
> Fixed by remove setting start/stop condition from the transmit routines.
>
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

Acked-by: Vitaly Wool <vitalywool@gmail.com>
