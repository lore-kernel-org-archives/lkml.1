Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0BBSVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:21:00 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:50979 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756623Ab0BBSU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:20:58 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PWM PATCH 1/5] API to consolidate PWM devices behind a common user and kernel interface
Date: Tue, 2 Feb 2010 13:20:55 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909020E99E1@mi8nycmail19.Mi8.com>
In-Reply-To: <c5873aa7c5d20254a9e54fc1ff179345b77c16b5.1265094517.git.bgat@billgatliff.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PWM PATCH 1/5] API to consolidate PWM devices behind a common user and kernel interface
Thread-Index: Acqj16fGQIbbe2TTS6qu8c6pDrkjVgAW3/GA
References: <cover.1265094517.git.bgat@billgatliff.com> <c5873aa7c5d20254a9e54fc1ff179345b77c16b5.1265094517.git.bgat@billgatliff.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Bill Gatliff" <bgat@billgatliff.com>, <linux-embedded@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Feb 2010 18:20:56.0128 (UTC) FILETIME=[762B3C00:01CAA434]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 02, 2010 12:15 AM, Bill Gatliff wrote:
> Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
> ---
>  Documentation/pwm.txt   |  260 +++++++++++++++++++
>  drivers/pwm/pwm.c       |  633 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pwm.h     |   31 ---
>  include/linux/pwm/pwm.h |  170 +++++++++++++
>  4 files changed, 1063 insertions(+), 31 deletions(-)
>  create mode 100644 Documentation/pwm.txt
>  create mode 100644 drivers/pwm/pwm.c
>  delete mode 100644 include/linux/pwm.h
>  create mode 100644 include/linux/pwm/pwm.h

A couple quick comments, more after a better review.

[snip]

> diff --git a/drivers/pwm/pwm.c b/drivers/pwm/pwm.c
> new file mode 100644
> index 0000000..f369384
> --- /dev/null
> +++ b/drivers/pwm/pwm.c

[snip]

> +int pwm_unregister(struct pwm_device *pwm)
> +{

[snip]

> +	for (wchan = 0; wchan < pwm->nchan; wchan++) {
> +		if (pwm->channels[wchan].flags & FLAG_REQUESTED) {

Shouldn't this be:

	& BIT(FLAG_REQUESTED)

[snip]

> diff --git a/include/linux/pwm/pwm.h b/include/linux/pwm/pwm.h
> new file mode 100644
> index 0000000..848cd76
> --- /dev/null
> +++ b/include/linux/pwm/pwm.h
> @@ -0,0 +1,170 @@
> +#ifndef __LINUX_PWM_H
> +#define __LINUX_PWM_H

Nitpick... Can you move the #ifndef/#define to after the comment?

Regards,
Hartley
