Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbZBEIJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbZBEIJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZBEII5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:08:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbZBEII4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:08:56 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 30/41] ACPI EC: Fix regression due to use of uninitialized variable
Date: Thu, 5 Feb 2009 09:08:42 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-HEAD_20090130075504_71baee03-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
References: <20090204184029.881610776@mini.kroah.org> <20090204184648.GE25246@kroah.com>
In-Reply-To: <20090204184648.GE25246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050908.45994.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 04 February 2009 19:46:48 Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us
> know.
Does this one patch cleanly in 2.6.27-stable?
I had it on my list, but this seem to have been introduced after
2.6.27 and I thought I removed this one again?
Or this is a follow up of another fix that should go in?

   Thomas

> ------------------
>
> From: Alexey Starikovskiy <astarikovskiy@suse.de>
>
> commit d21cf3c16b1191f3154a51e0b20c82bf851cc553 upstream.
>
> breakage introduced by following patch
> commit 27663c5855b10af9ec67bc7dfba001426ba21222
> Author: Matthew Wilcox <willy@linux.intel.com>
> Date:   Fri Oct 10 02:22:59 2008 -0400
>
> acpi_evaluate_integer() does not clear passed variable if
> there is an error at evaluation.
> So if we ignore error, we must supply initialized variable.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=11917
>
> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: Thomas Renninger <trenn@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/acpi/ec.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -769,7 +769,7 @@ static acpi_status
>  ec_parse_device(acpi_handle handle, u32 Level, void *context, void
> **retval) {
>  	acpi_status status;
> -	unsigned long long tmp;
> +	unsigned long long tmp = 0;
>
>  	struct acpi_ec *ec = context;
>  	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
> @@ -784,6 +784,7 @@ ec_parse_device(acpi_handle handle, u32
>  		return status;
>  	ec->gpe = tmp;
>  	/* Use the global lock for all EC transactions? */
> +	tmp = 0;
>  	acpi_evaluate_integer(handle, "_GLK", NULL, &tmp);
>  	ec->global_lock = tmp;
>  	ec->handle = handle;

