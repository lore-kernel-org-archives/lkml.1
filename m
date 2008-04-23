Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYDWIUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYDWIUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYDWITu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:19:50 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:64669 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYDWITr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:19:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cgNA6rvDSCq5Eo5WOHdGtysoU6CetxzIO5AlyfFp2nAmDZGBDgV70SN8DVhSY/K1WzHr+yfnzixL51UdbSCOdupx3KSMXhqf2pNQXJgUemb3VRKAVd3Er/GJlFzAb+DFXBqnjetuB1ccWZIOiSRxboWZuYxkYFG7d6KG29Avrqw=
Message-ID: <e1d5030b0804230119g7d784168q42191e869f9b9149@mail.gmail.com>
Date: Wed, 23 Apr 2008 13:49:46 +0530
From: "Midhun A" <midhunagni@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: Userspace - Kernel Space "Connector" test
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080421104301.GA2061@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e1d5030b0803260311j25831caeyd9fc111a06e572e2@mail.gmail.com>
	 <20080327143823.GA20443@2ka.mipt.ru>
	 <e1d5030b0804040001t2a2b2fd3j75c656ec2318a932@mail.gmail.com>
	 <e1d5030b0804210329j38d3bb8cge62e833088c1e0c@mail.gmail.com>
	 <20080421104301.GA2061@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I had changed the group number. It worked ! Thanks a lot for the help
and also also the code !

Regards,
Midhun

On Mon, Apr 21, 2008 at 4:13 PM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Hi.
>
>
>
>  On Mon, Apr 21, 2008 at 03:59:32PM +0530, Midhun A (midhunagni@gmail.com) wrote:
>  > static void imxmci_check_status(unsigned long data)
>  > {
>  >       struct imxmci_host *host = (struct imxmci_host *)data;
>  >
>  >       /*Netlink*/
>  >       struct cn_msg *m;
>  >       char cn_data[32] = "SD/MMC Card Status";
>  >       /*Netlink*/
>  >
>  >       if( host->pdata->card_present() != host->present ) {
>  >               host->present ^= 1;
>  >               dev_info(mmc_dev(host->mmc), "card %s\n",
>  >                     host->present ? "inserted" : "removed");
>  >
>  >       /*Netlink*/
>  >
>  >       m = kmalloc(sizeof(*m) + sizeof(cn_data), GFP_ATOMIC);
>  >
>  >       if (m) {
>  >               printk("Inside if\n");
>  >               memset(m, 0, sizeof(*m) + sizeof(cn_data));
>  >               memcpy(&m->id, &cn_test_id, sizeof(m->id));
>  >               m->seq = cn_test_timer_counter;
>  >               m->len = sizeof(cn_data);
>  >
>  >               m->len =
>  >                   scnprintf(cn_data, sizeof(cn_data), "counter = %u",
>  >                             cn_test_timer_counter) + 1;
>  >
>  >               memcpy(m + 1, data, m->len);
>  >               printk("Copied Message\n");
>  >               cn_netlink_send(m, 0, gfp_any());
>  >               printk("Sent Message\n");
>  >               kfree(m);
>
>  What is return value here?
>  Also, do you register this driver as connector user? If not, you can not
>  use 0 group number, since it will search only for registered kernel
>  side, and if there was no registration, it can not obtain address of the
>  userspace side. You can specify group (7 in your cae) as a parameter
>  instead.
>
>  I suppose userspace was bound to (1<<7) group number or was subscribed
>  using socket option to 7'th group.
>
>  --
>         Evgeniy Polyakov
>
