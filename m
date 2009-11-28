Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbZK1KA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbZK1KA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 05:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZK1KA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 05:00:28 -0500
Received: from ozlabs.org ([203.10.76.45]:60632 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZK1KA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 05:00:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ian Molton <ian.molton@collabora.co.uk>
Subject: Re: [PATCH 2/2] virtio: Convert virtio-rng to the new API
Date: Sat, 28 Nov 2009 20:30:31 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com
References: <1259177252.2858.17.camel@calx> <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk> <1259195127-20086-3-git-send-email-ian.molton@collabora.co.uk>
In-Reply-To: <1259195127-20086-3-git-send-email-ian.molton@collabora.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911282030.32015.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009 10:55:27 am Ian Molton wrote:
> 	This patch converts virtio-rng to the new hw_rng API.
> 
> In the process it fixes a previously untriggered buffering bug where the
> buffer is not drained correctly if it has a non-multiple-of-4 length.

Hi Ian,

	Looks good.  Minor comments below:

> @@ -16,6 +16,7 @@
>   *  along with this program; if not, write to the Free Software
>   *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
>   */
> +
>  #include <linux/err.h>
>  #include <linux/hw_random.h>
>  #include <linux/scatterlist.h>

Gratuitous hunk?

> -static unsigned int data_left;
> +static unsigned int data_avail;
>  static DECLARE_COMPLETION(have_data);
> +static int busy;

I prefer bool and true/false for booleans these days.

> +
> +/* The host will fill any buffer we give it with sweet, sweet randomness. */

This comment belongs above register_buffer() now I think.

(But I'm glad you kept it!)

Thanks,
Rusty.
