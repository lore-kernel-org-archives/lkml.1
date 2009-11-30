Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZK3J4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZK3J4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZK3J4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:56:16 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:33534 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZK3J4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:56:16 -0500
Message-ID: <4B13969E.3020505@collabora.co.uk>
Date: Mon, 30 Nov 2009 09:55:42 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: [PATCH 2/2] virtio: Convert virtio-rng to the new API
References: <1259177252.2858.17.camel@calx> <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk> <1259195127-20086-3-git-send-email-ian.molton@collabora.co.uk> <200911282030.32015.rusty@rustcorp.com.au>
In-Reply-To: <200911282030.32015.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thu, 26 Nov 2009 10:55:27 am Ian Molton wrote:
>> 	This patch converts virtio-rng to the new hw_rng API.
>>
>> In the process it fixes a previously untriggered buffering bug where the
>> buffer is not drained correctly if it has a non-multiple-of-4 length.
> 
> Hi Ian,

Hi!

> 	Looks good.  Minor comments below:
> 
>> @@ -16,6 +16,7 @@
>>   *  along with this program; if not, write to the Free Software
>>   *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
>>   */
>> +
>>  #include <linux/err.h>
>>  #include <linux/hw_random.h>
>>  #include <linux/scatterlist.h>
> 
> Gratuitous hunk?

Didn't look right without a gap :)

>> -static unsigned int data_left;
>> +static unsigned int data_avail;
>>  static DECLARE_COMPLETION(have_data);
>> +static int busy;
> 
> I prefer bool and true/false for booleans these days.

I was wondering what the current opinion was on that one. I have to say
I prefer it too, so I'll change that.

>> +
>> +/* The host will fill any buffer we give it with sweet, sweet randomness. */
> 
> This comment belongs above register_buffer() now I think.

Yeah, didnt wanna make too much fus over it though. I'll move it too
then :-)

> (But I'm glad you kept it!)

I think a sense of humour is important ;-)

Patch to follow.

-Ian

