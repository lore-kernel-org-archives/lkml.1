Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZJ3BOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZJ3BOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 21:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZJ3BOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 21:14:04 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45284 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753880AbZJ3BOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 21:14:03 -0400
Message-ID: <4AEA3DC9.7080205@snapgear.com>
Date: Fri, 30 Oct 2009 11:13:45 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v4 7/7] m68knommu: Split the .init section into INIT_TEXT_SECTION
 and INIT_DATA_SECTION.
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu> <1255886635-17371-7-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1255886635-17371-7-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

The whole series applied and ran fine for me!
(Of course excepting the define name clash in 1/7)

Do you want me to push these into m68knommu.git?

Regards
Greg



Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> ---
>  arch/m68knommu/kernel/vmlinux.lds.S |   17 ++++-------------
>  1 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> index 65e2874..2bff62f 100644
> --- a/arch/m68knommu/kernel/vmlinux.lds.S
> +++ b/arch/m68knommu/kernel/vmlinux.lds.S
> @@ -154,22 +154,13 @@ SECTIONS {
>  		_edata = . ;
>  	} > DATA
>  
> -	.init : {
> +	.init.text : {
>  		. = ALIGN(PAGE_SIZE);
>  		__init_begin = .;
>  	} > INIT
> -	.init : {
> -		_sinittext = .;
> -		INIT_TEXT
> -		_einittext = .;
> -		INIT_DATA
> -		INIT_SETUP(16)
> -		INIT_CALLS
> -		CON_INITCALL
> -		SECURITY_INITCALL
> -		INIT_RAM_FS
> -	} > INIT
> -	.init : {
> +	INIT_TEXT_SECTION(PAGE_SIZE) > INIT
> +	INIT_DATA_SECTION(16) > INIT
> +	.init.data : {
>  		. = ALIGN(PAGE_SIZE);
>  		__init_end = .;
>  	} > INIT

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
