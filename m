Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZFXKo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZFXKo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZFXKos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:44:48 -0400
Received: from tundra.namei.org ([65.99.196.166]:42842 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbZFXKos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:44:48 -0400
Date: Wed, 24 Jun 2009 20:44:09 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Joseph Cihula <joseph.cihula@intel.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: Re: [RFC v5][PATCH 1/4] intel_txt: Intel(R) TXT boot support
In-Reply-To: <4A4024BA.9040505@intel.com>
Message-ID: <alpine.LRH.2.00.0906242043171.18503@tundra.namei.org>
References: <4A4024BA.9040505@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Joseph Cihula wrote:


> +void tboot_copy_fadt(const struct acpi_table_fadt *fadt)
> +{
> +#define TB_COPY_GAS(tbg, g)			\
> +	tbg.space_id     = g.space_id;		\
> +	tbg.bit_width    = g.bit_width;		\
> +	tbg.bit_offset   = g.bit_offset;	\
> +	tbg.access_width = g.access_width;	\
> +	tbg.address      = g.address;
> +
> +	TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1a_cnt_blk,
> +		    fadt->xpm1a_control_block);
> +	TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1b_cnt_blk,
> +		    fadt->xpm1b_control_block);
> +	TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1a_evt_blk,
> +		    fadt->xpm1a_event_block);
> +	TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1b_evt_blk,
> +		    fadt->xpm1b_event_block);

Not a showstopper, but why not simply make a static tb_copy_gas() 
function?

-- 
James Morris
<jmorris@namei.org>
