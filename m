Return-Path: <linux-kernel-owner+w=401wt.eu-S1160996AbXBPNzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160996AbXBPNzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1160999AbXBPNzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:55:15 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:33446 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964834AbXBPNzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:55:12 -0500
From: John Keller <jpk@sgi.com>
Message-Id: <200702161353.l1GDrq4q413863@fcbayern.americas.sgi.com>
Subject: Re: [PATCH 1/1] -  acpi_unload_table_id() always returns error
To: lenb@kernel.org (Len Brown)
Date: Fri, 16 Feb 2007 07:53:51 -0600 (CST)
Cc: jpk@sgi.com (John Keller), linux-acpi@vger.kernel.org, ayoung@sgi.com,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200702152329.55535.lenb@kernel.org> from "Len Brown" at Feb 15, 2007 11:29:55 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes.

      I understand and agree this project and the contribution
      are public and that a record of the contribution (including all
      personal information I submit with it, including my sign-off) is
      maintained indefinitely. I thereby license this patch to be
      redistributed under any license (GPL or non-GPL) consistent
      with the project.

John


> 
> Thanks for the fix, John.
> Do you grant Intel permission to apply it to the upstream ACPICA tree (with its non-GPL license)?
> 
> -Len
> 
> On Thursday 15 February 2007 15:08, John Keller wrote:
> > acpi_unload_table_id() is always returning an error status.
> > Also, once the matching table is found, don't bother looking
> > for another match.
> > 
> > 
> > Signed-off-by: John Keller <jpk@sgi.com>
> > ---
> > 
> > 
> > Index: release/drivers/acpi/tables/tbxface.c
> > ===================================================================
> > --- release.orig/drivers/acpi/tables/tbxface.c	2007-02-13 08:20:42.000000000 -0600
> > +++ release/drivers/acpi/tables/tbxface.c	2007-02-15 14:04:07.855248010 -0600
> > @@ -338,9 +338,9 @@ acpi_status acpi_unload_table_id(acpi_ow
> >  	int i;
> >  	acpi_status status = AE_NOT_EXIST;
> >  
> > -	ACPI_FUNCTION_TRACE(acpi_unload_table);
> > +	ACPI_FUNCTION_TRACE(acpi_unload_table_id);
> >  
> > -	/* Find table from the requested type list */
> > +	/* Find table in the global table list */
> >  	for (i = 0; i < acpi_gbl_root_table_list.count; ++i) {
> >  		if (id != acpi_gbl_root_table_list.tables[i].owner_id) {
> >  			continue;
> > @@ -352,8 +352,9 @@ acpi_status acpi_unload_table_id(acpi_ow
> >  		* simply a position within the hierarchy
> >  		*/
> >  		acpi_tb_delete_namespace_by_owner(i);
> > -		acpi_tb_release_owner_id(i);
> > +		status = acpi_tb_release_owner_id(i);
> >  		acpi_tb_set_table_loaded_flag(i, FALSE);
> > +		break;
> >  	}
> >  	return_ACPI_STATUS(status);
> >  }
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 

