Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbZJHR0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbZJHR0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932677AbZJHR0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:26:36 -0400
Received: from outbound-mail-317.bluehost.com ([67.222.54.10]:37615 "HELO
	outbound-mail-317.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932651AbZJHR0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:26:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Sro0X7szh63IB8wXIutewhv+rgusf2x7NRtIEAPpYlGRuL/L1gDGQaQB8o94eiTIzWgS73K8VDLG8+nwlbLhvnrgYTFD1fkhcB8OQD40914Ha1H1ZLxGZ9b2cyjOfp6I;
Date: Thu, 8 Oct 2009 10:25:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH pci-2.6#linux-next] pci: pci_dfl_cache_line_size is
 __devinitdata
Message-ID: <20091008102542.4006c04c@jbarnes-g45>
In-Reply-To: <4ACDB819.4060606@kernel.org>
References: <20091008152725.1351485a.sfr@canb.auug.org.au>
	<4ACDB819.4060606@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Oct 2009 18:59:53 +0900
Tejun Heo <tj@kernel.org> wrote:

> pci_dfl_cache_line_size is marked as __initdata but referenced by
> pci_init() which is __devinit.  Make it __devinitdata instead of
> __initdata.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/pci/pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 1ae95df..a6e22fd 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -53,7 +53,7 @@ unsigned long pci_hotplug_mem_size =
> DEFAULT_HOTPLUG_MEM_SIZE;
>   * the dfl or actual value as it sees fit.  Don't forget this is
>   * measured in 32-bit words, not bytes.
>   */
> -u8 pci_dfl_cache_line_size __initdata = L1_CACHE_BYTES >> 2;
> +u8 pci_dfl_cache_line_size __devinitdata = L1_CACHE_BYTES >> 2;
>  u8 pci_cache_line_size;

Fix pushed, thanks for the quick turnaround Tejun.

-- 
Jesse Barnes, Intel Open Source Technology Center
