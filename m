Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbYJNOlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbYJNOlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYJNOlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:41:16 -0400
Received: from kroah.org ([198.145.64.141]:38626 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751240AbYJNOlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:41:15 -0400
Date: Tue, 14 Oct 2008 07:37:44 -0700
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 6/8 v4] PCI: support the SR-IOV capability
Message-ID: <20081014143744.GA12251@kroah.com>
References: <20081014103424.GA1704@yzhao12-linux.sh.intel.com> <20081014105928.GF1734@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014105928.GF1734@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 06:59:28PM +0800, Yu Zhao wrote:
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

Why isn't this a real struct device?

That way you get all of the proper userspace notification and the like,
with kobjects, you do not.

thanks,

greg k-h
