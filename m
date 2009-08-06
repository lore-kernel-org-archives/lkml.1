Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZHFGyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZHFGyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZHFGye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:54:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:54026 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZHFGyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xVn3yJUmoCjOXox51/d80Sqe3plJIxJ2h/1UOpZSyWupcTpqVKqSzaHSqCE4WvJg/0
         5bogVaX+QViLX9j4nqPK1r4A3VRt6VUVqL22od9qsN6fU8vMDM3PFXvujwNE+HSel9tI
         I5Ae8VSdzqDbMOtyQ+Pc3YSCY/2PCGAhkrFGg=
MIME-Version: 1.0
In-Reply-To: <1247518987-10818-2-git-send-email-mjg@redhat.com>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com>
	 <1247518987-10818-2-git-send-email-mjg@redhat.com>
Date: Thu, 6 Aug 2009 08:54:31 +0200
Message-ID: <a01a16b50908052354h28522bafja255c4fcac9a2ea8@mail.gmail.com>
Subject: Re: [PATCH 2/3] libata: Bind the Linux device tree to the ACPI device 
	tree
From: =?UTF-8?B?SMOla29uIEzDuHZkYWw=?= <hlovdal@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       shaohua.li@intel.com, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/13 Matthew Garrett <mjg@redhat.com>:
> +               if (!sata_pmp_attached(ap))
> +                       adr = SATA_ADR(ap->port_no, NO_PORT_MULT);
> +               else
> +                       adr = SATA_ADR(ap->port_no, dev->link->pmp);

Maybe I am missing something, but wouldn't it be more natural to write this as

        if (sata_pmp_attached(ap))
                adr = SATA_ADR(ap->port_no, dev->link->pmp);
        else
                adr = SATA_ADR(ap->port_no, NO_PORT_MULT);

BR Håkon Løvdal
