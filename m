Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYJNMab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYJNMab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbYJNMaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:30:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36360 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYJNMaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:30:20 -0400
Date: Tue, 14 Oct 2008 06:30:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 6/8 v4] PCI: support the SR-IOV capability
Message-ID: <20081014123002.GA15064@parisc-linux.org>
References: <20081014103424.GA1704@yzhao12-linux.sh.intel.com> <20081014105928.GF1734@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014105928.GF1734@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 06:59:28PM +0800, Yu Zhao wrote:
> +++ b/drivers/pci/pci.h
> @@ -176,4 +176,59 @@ static inline int pci_ari_enabled(struct pci_dev *dev)
> +struct pci_iov {
> +	int cap;		/* capability position */
> +	int align;		/* page size used to map memory space */
> +	int is_enabled;		/* status of SR-IOV */
> +	int nentries;		/* number of sysfs entries used by PF driver */
> +	u16 totalvfs;		/* total VFs associated with the PF */
> +	u16 initialvfs;		/* initial VFs associated with the PF */
> +	u16 numvfs;		/* number of VFs available */
> +	u16 offset;		/* first VF Routing ID offset */
> +	u16 stride;		/* following VF stride */
> +	struct mutex mutex;	/* lock for SR-IOV */
> +	struct kobject kobj;	/* koject for IOV */
> +	struct pci_dev *dev;	/* Physical Function */
> +	struct vf_entry *ve;	/* Virtual Function related */
> +	int (*notify)(struct pci_dev *, u32);	/* event callback function */
> +};

> +++ b/include/linux/pci.h
> @@ -87,6 +87,12 @@ enum {
>  	/* #6: expansion ROM */
>  	PCI_ROM_RESOURCE,
>  
> +	/* device specific resources */
> +#ifdef CONFIG_PCI_IOV
> +	PCI_IOV_RESOURCES,
> +	PCI_IOV_RESOURCES_END = PCI_IOV_RESOURCES + PCI_IOV_NUM_BAR - 1,
> +#endif
> +
>  	/* address space assigned to buses behind the bridge */
>  #ifndef PCI_BRIDGE_RES_NUM
>  #define PCI_BRIDGE_RES_NUM 4

Why expand the number of resources in struct pci_dev instead of putting
the new resources in struct pci_iov?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
