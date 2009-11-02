Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbZKBQt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbZKBQt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbZKBQt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:49:57 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:41288 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbZKBQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:49:56 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH] trivial: remove ACPI_ARRAY_LENGTH macro.
Date: Mon, 2 Nov 2009 10:49:55 -0600
User-Agent: KMail/1.9.10
Cc: trivial@kernel.org, lenb@kernel.org, ming.m.lin@intel.com,
       robert.moore@intel.com, jkosina@suze.cz, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1257114972-16039-1-git-send-email-tfransosi@gmail.com>
In-Reply-To: <1257114972-16039-1-git-send-email-tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911020949.58412.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 November 2009 03:36:12 pm Thiago Farina wrote:
> Since the kernel already has a macro (ARRAY_SIZE) that does the same thing,
> just use it instead of defining another macro for the same propose.

This changes the ACPICA, which is used in several OSes besides Linux.
The CA is designed to have a small, controlled interface to the host OS.
This patch would expand that interface, which would work fine on Linux,
but would cause problems on other OSes that don't provide ARRAY_SIZE().

It'd be nice to have a little text in Documentation/acpi/ that covered
issues like this.  It could also talk about the special licensing
requirements for ACPICA changes.  And MAINTAINERS could mention it for
the path prefix "drivers/acpi/acpica/".

Bjorn

>  drivers/acpi/acpica/hwvalid.c |    2 +-
>  drivers/acpi/acpica/uteval.c  |    4 ++--
>  include/acpi/actypes.h        |    4 ----
>  3 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/hwvalid.c b/drivers/acpi/acpica/hwvalid.c
> index ec33f27..ca2eb02 100644
> --- a/drivers/acpi/acpica/hwvalid.c
> +++ b/drivers/acpi/acpica/hwvalid.c
> @@ -103,7 +103,7 @@ static const struct acpi_port_info acpi_protected_ports[] = {
>  	{"PCI", 0x0CF8, 0x0CFF, ACPI_OSI_WIN_XP}
>  };
>  
> -#define ACPI_PORT_INFO_ENTRIES  ACPI_ARRAY_LENGTH (acpi_protected_ports)
> +#define ACPI_PORT_INFO_ENTRIES  ARRAY_SIZE(acpi_protected_ports)
>  
>  /******************************************************************************
>   *
> diff --git a/drivers/acpi/acpica/uteval.c b/drivers/acpi/acpica/uteval.c
> index 5d54e36..54efbaa 100644
> --- a/drivers/acpi/acpica/uteval.c
> +++ b/drivers/acpi/acpica/uteval.c
> @@ -126,7 +126,7 @@ acpi_status acpi_ut_osi_implementation(struct acpi_walk_state *walk_state)
>  
>  	/* Compare input string to static table of supported interfaces */
>  
> -	for (i = 0; i < ACPI_ARRAY_LENGTH(acpi_interfaces_supported); i++) {
> +	for (i = 0; i < ARRAY_SIZE(acpi_interfaces_supported); i++) {
>  		if (!ACPI_STRCMP(string_desc->string.pointer,
>  				 acpi_interfaces_supported[i].name)) {
>  			/*
> @@ -186,7 +186,7 @@ acpi_status acpi_osi_invalidate(char *interface)
>  {
>  	int i;
>  
> -	for (i = 0; i < ACPI_ARRAY_LENGTH(acpi_interfaces_supported); i++) {
> +	for (i = 0; i < ARRAY_SIZE(acpi_interfaces_supported); i++) {
>  		if (!ACPI_STRCMP(interface, acpi_interfaces_supported[i].name)) {
>  			*acpi_interfaces_supported[i].name = '\0';
>  			return AE_OK;
> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
> index 153f12d..641d746 100644
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -441,10 +441,6 @@ typedef unsigned long long acpi_integer;
>  #define ACPI_MIN(a,b)                   (((a)<(b))?(a):(b))
>  #define ACPI_MAX(a,b)                   (((a)>(b))?(a):(b))
>  
> -/* Size calculation */
> -
> -#define ACPI_ARRAY_LENGTH(x)            (sizeof(x) / sizeof((x)[0]))
> -
>  /* Pointer manipulation */
>  
>  #define ACPI_CAST_PTR(t, p)             ((t *) (acpi_uintptr_t) (p))


