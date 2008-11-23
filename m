Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYLBOkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYLBOkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 09:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYLBOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 09:40:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39338 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754267AbYLBOkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 09:40:22 -0500
Date: Sun, 23 Nov 2008 19:04:09 +0100
From: Pavel Machek <pavel@suse.cz>
To: Cristiano Prisciandaro <cristiano.p@solnet.ch>
Cc: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
Message-ID: <20081123180409.GB7731@ucw.cz>
References: <1227454026.7262.59.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227454026.7262.59.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-11-23 16:27:06, Cristiano Prisciandaro wrote:
> From: Cristiano Prisciandaro <cristiano.p@solnet.ch>
> 
> The bios of the eeepc 900 exposes an acpi method that allows clocking
> the cpu to 630/900 MHz. This driver allows controlling the frequency
> switch through the cpufreq subsystem.

Is this really needed? Could we simply talk to the cpu directly,
without help of ACPI?

> +/* write to the acpi handle (from asus_acpi.c) */
> +static int write_eee900_acpi_int(acpi_handle handle, const char *method,
> +				 int val, struct acpi_buffer *output)
> +{
> +	struct acpi_object_list params;
> +	union acpi_object in_obj;
> +	acpi_status status;
> +
> +	params.count = 1;
> +	params.pointer = &in_obj;
> +	in_obj.type = ACPI_TYPE_INTEGER;
> +	in_obj.integer.value = val;
> +	status = acpi_evaluate_object(handle, (char *)method, &params, output);
> +	return status == AE_OK;
> +}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
