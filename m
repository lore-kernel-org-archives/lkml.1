Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbYEQSqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbYEQSqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 14:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYEQSq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 14:46:29 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:49889 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbYEQSq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 14:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HhYfyv00DJZXWsyi9xONyuy+k9j7ydvGRAzvQ7P2H7wO0xaj8kIqbGTqcXU/7UjpqBGqPOKk5B9Bu6ra7csBMUQhlzWzoYEG4hbl11Zqe/I95g6QXxI5CZBqeDGxGhKma1hd4HfDhw2uLKDL0qNas3DxHjgL2KvUafCjtoCrlVI=
Message-ID: <e2e108260805171146x196e89f0s28d20c52d85ab417@mail.gmail.com>
Date: Sat, 17 May 2008 20:46:27 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jay Cliburn" <jacliburn@bellsouth.net>
Subject: Re: 2.6.25.3: serial problem (minicom)
Cc: "Chris Rankin" <rankincj@yahoo.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080517101026.270a6f4e@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080517082207.4b1e8556@osprey.hogchain.net>
	 <543631.10570.qm@web52902.mail.re2.yahoo.com>
	 <20080517101026.270a6f4e@osprey.hogchain.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 5:10 PM, Jay Cliburn <jacliburn@bellsouth.net> wrote:
> On Sat, 17 May 2008 15:49:08 +0100 (BST)
> Chris Rankin <rankincj@yahoo.com> wrote:
>
>> Does yours still work if you raise the baud rate to 115200?
>
> No, but I also get garbage characters and a generally unusable logging
> device.  57600 is slightly better, but not much.  I remember going
> through this progressive reduction in baud rate a long time ago,
> trying to find a speed that works reliably, which is why I settled on
> 38400. I get unpredictable results for anything higher.

If you have a digital oscilloscope available it would be very
interesting to measure whether the timing of the signals sent out on
the Tx line is correct. Small deviations between the frequency of the
clock crystal that drives a UART and the value configured via
setserial can cause trouble with serial communication (baud_base must
be configured to UART clock crystal frequency / 16).

# setserial -g -a /dev/ttyS0
/dev/ttyS0, Line 0, UART: 16550A, Port: 0x03f8, IRQ: 4
        Baud_base: 115200, close_delay: 50, divisor: 0
        closing_wait: 3000
        Flags: spd_normal skip_test

Bart.
